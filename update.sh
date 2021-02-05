#!/bin/bash
set -eo pipefail

declare -A compose=(
	[debian]='debian'
	[alpine]='alpine'
)

declare -A base=(
	[debian]='debian'
	[alpine]='alpine'
)

declare -A dockerVariant=(
	[debian]='debian'
	[alpine]='alpine'
)

variants=(
	debian
	alpine
)

min_version='1.0'
dockerLatest='1.0'
dockerDefaultVariant='alpine'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

dockerRepo="monogramm/docker-__app_slug__"
# Retrieve automatically the latest versions
#latests=( $( curl -fsSL 'https://api.github.com/repos/__app_owner_slug__/__app_slug__/tags' |tac|tac| \
#	grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
#	sort -urV ) )
latests=( 1.0.0 )

# Remove existing images
echo "reset docker images"
rm -rf ./images/
mkdir ./images/

echo "update docker images"
readmeTags=
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

		for variant in "${variants[@]}"; do
			# Create the version directory with a Dockerfile.
			dir="images/$version/$variant"
			if [ -d "$dir" ]; then
				continue
			fi
			echo "Updating $latest [$version-$variant]"
			mkdir -p "$dir"

			template="Dockerfile.${base[$variant]}"
			cp "template/$template" "$dir/Dockerfile"
			cp "template/entrypoint.sh" "$dir/entrypoint.sh"

			cp "template/.dockerignore" "$dir/.dockerignore"
			cp -r "template/hooks" "$dir/"
			cp -r "template/test" "$dir/"
			cp "template/.env" "$dir/.env"
			cp "template/docker-compose_${compose[$variant]}.yml" "$dir/docker-compose.test.yml"

			# Replace the variables.
			sed -ri -e '
				s/%%VARIANT%%/-'"$variant"'/g;
				s/%%VERSION%%/'"$latest"'/g;
			' "$dir/Dockerfile"

			sed -ri -e '
				s|DOCKER_TAG=.*|DOCKER_TAG='"$version"'|g;
				s|DOCKER_REPO=.*|DOCKER_REPO='"$dockerRepo"'|g;
			' "$dir/hooks/run"

			# Create a list of "alias" tags for DockerHub post_push
			tagVariant=${dockerVariant[$variant]}
			if [ "$version" = "$dockerLatest" ]; then
				if [ "$tagVariant" = "$dockerDefaultVariant" ]; then
					export DOCKER_TAGS="$latest-$tagVariant $version-$tagVariant $tagVariant $latest $version latest "
				else
					export DOCKER_TAGS="$latest-$tagVariant $version-$tagVariant $tagVariant "
				fi
			elif [ "$version" = "$latest" ]; then
				if [ "$tagVariant" = "$dockerDefaultVariant" ]; then
					export DOCKER_TAGS="$latest-$tagVariant $latest "
				else
					export DOCKER_TAGS="$latest-$tagVariant "
				fi
			else
				if [ "$tagVariant" = "$dockerDefaultVariant" ]; then
					export DOCKER_TAGS="$latest-$tagVariant $version-$tagVariant $latest $version "
				else
					export DOCKER_TAGS="$latest-$tagVariant $version-$tagVariant "
				fi
			fi
			echo "${DOCKER_TAGS} " > "$dir/.dockertags"

			# Add README tags
			readmeTags="$readmeTags\n-   ${DOCKER_TAGS} (\`$dir/Dockerfile\`)"

			# Add Travis-CI env var
			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version-$variant"
				echo "Build Dockerfile for ${tag}"
				docker build -t "${dockerRepo}:${tag}" "$dir"
			fi
		done
	fi

done

# update README.md
sed '/^<!-- >Docker Tags -->/,/^<!-- <Docker Tags -->/{/^<!-- >Docker Tags -->/!{/^<!-- <Docker Tags -->/!d}}' README.md > README.md.tmp
sed -e "s|<!-- >Docker Tags -->|<!-- >Docker Tags -->\n$readmeTags\n|g" README.md.tmp > README.md
rm README.md.tmp

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
