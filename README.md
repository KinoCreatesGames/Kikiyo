# Kikiyo
> A LoZ type game that focuses on system gameplay mechanics.

### 1. Download

You can also create a new project based on this template using degit which will ignore all git related files.
```sh
npx degit KinoCreatesGames/flixel-base my-flixel-game
cd my-flixel-game
```

### 2. Install dependencies

```sh
npm i 
```

### 3. Build
It's recommended to run the [Haxe compilation server](https://youtu.be/3crCJlVXy-8) when developing to cache the compilation, this should be done in a separate terminal window/tab with the following command.
```sh
npm run comp-server
```

Your **.hx** files are watched with [Facebook's watman plugin](https://facebook.github.io/watchman/). Anytime you save a file it will trigger an automatic rebuild. 
```sh
npm start 
```
