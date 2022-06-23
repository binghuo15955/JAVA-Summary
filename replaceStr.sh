find . -name '*.md' | xargs perl -pi -e 's|==||g'
# find -name '要查找的文件名' | xargs perl -pi -e 's|被替换的字符串|替换后的字符串|g'