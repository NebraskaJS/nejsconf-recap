# uses https://github.com/sindresorhus/file-type-cli
filemap=""
addComma="no"

function getAvatar() {
  filename=$1
  src=$2
  wget --quiet -O img/${filename} $src
}

function optimizeImageByFileName() {
  handle=$1
  extension=$1
  file="img/${filename}"
  type=$(file-type $file)
  if [[ $type == *"image/jpeg"* ]]
  then
    jpegtran "$file" > "$file."
    mv "$file." "$file"
  fi

  if [[ $type == *"image/png"* ]]
  then
    pngcrush -brute "$file"{,.}
    rm "img/${filename}"
    mv "img/${filename}." "img/${filename}"
  fi
}

function optimizeImage() {
  handle=$1
  file="img/${handle}.jpg"
  type=$(file-type $file)
  if [[ $type == *"image/jpeg"* ]]
  then
    jpegtran "$file" > "$file."
    mv "$file." "$file"
  fi

  if [[ $type == *"image/png"* ]]
  then
    pngcrush -brute "$file"{,.}
    rm img/${handle}.jpg
    mv img/${handle}.jpg. img/${handle}.png

    if [[ "$addComma" == "no" ]]
    then
      addComma="yes"
    else
      filemap="$filemap,"
    fi
    filemap="$filemap\n\t\"$handle\": \"$handle.png\""
  fi
}

# Testimonials
for handle in $(cat _data/speakers.json | jq -r '.[] | .twitter'); do
  if [[ "$handle" == "" || "$handle" == "null" ]]
  then
    echo "$handle is not valid";
  else
    echo ${handle}
    getAvatar "$handle.jpg" "https://twitter.com/${handle}/profile_image?size=bigger"
    optimizeImage $handle
  fi
done

echo "{$filemap\n}" > _data/avatarFileMap.json