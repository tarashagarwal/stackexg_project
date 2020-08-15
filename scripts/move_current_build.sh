if [ -d /tmp/temp_app ]; then
  echo "Copying Exisitng Code to the app directory ... "
  cd /usr/src/
  rm -rf /usr/src/app/*
  cp -rf /tmp/temp_app/* /usr/src/app/
  rm -rf /tmp/temp_app
  echo "Copy Complete"
  cd  app/
  echo "Trigerring Gem Updates"
  bundle
fi