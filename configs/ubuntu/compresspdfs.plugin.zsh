compresspdfs() {
  for file in *.pdf;do
    compresspdf "$file" "${file%.pdf}"_compressed.pdf
    rm "$file"
    mv "${file%.pdf}"_compressed.pdf "$file"
  done
}
