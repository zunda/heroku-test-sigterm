# heroku-test-sigterm
A small worker app to see how SIGTERM is handled

## Create the app and run the dyno
```
heroku create
git push heroku main
heroku ps:scale worker=1
heroku logs -t
```

## SSH to the dyno and send signals
```
heroku ps:exec -d worker.1
ps xf
```

