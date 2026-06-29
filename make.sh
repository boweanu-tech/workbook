echo "---更新をダウンロード中---"

sh download.sh

echo "---TEXコンパイル中---"
cd ./101_books

bash ../999_GPTbox/cwork.sh

cd ../
echo "---更新をアップロード中---"
sh upload.sh
