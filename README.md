# 1. Prerequisites

Refer to MANUAL.md > 3. Installation/Configuration

# 2. Step-by-Step (VSCode)

Refer to MANUAL.md > 4. Working with projects

# 3. Auto-Completion (VSCode)

The project template comes with a preinstalled Auto-Completion for JQuery and ServiceNow.

For further Information or infos about updates on the related Typescript Definitions, look here:

* https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/jquery
* https://github.com/bryceg/servicenow-dts

# 3.1. GlideRecord Auto-Completion (VSCode)

If you want to use GlideRecord Auto-Completion, please visit: https://github.com/meinzeugde/sn-dts.

All necessary steps from the installation are already handled within MANUAL.md.

# 4. Running background scripts from within Terminal

For more information on running background scripts from within your IDE, visit: https://github.com/matthaak/snow-runner.

All necessary steps from the installation are already handled within MANUAL.md.

After installing the module from the repository, be sure modify the prepared Shell script in the root of this project: `snbs-global.sh`.
This way you'll have an easy way of running your background script from within your project including track of all previous runs in form of a logfile.

## 4.1. Starting the Script

Run the script from a Unix-Shell with the following command: `./snbs-global.sh`

## 4.2. Suggestion on application scopes

If you like to you can create a copy of this script for different application scopes.
Therefore you should also create a different file in folder `background_scripts`.

### 4.2.1. Preventing issues with multiple Application Scopes

FYI: The app 'snow-runner' will normally create 3 files ('.org.snowlib.snow-runner...') in your project root folder.
In one of those files, the application scope will be stored. If those files exist and you try to give a different application scope to the snow-runner via the parameter `--scope`, the app will anyway use the application scope stored in the temp file.
If you like to work with multiple application scopes, these temp files have to be removed. The shell script will take care of that.

# 5. Visual Studio Code Tasks

## 5.1 Synchronize the currently opened File with ServiceNow

### Prerequisites/Installation

Make sure to complete all steps in `MANUAL.md` > `3. Installation/Configuration`.

### Usage

You don't need to run the file watcher (`snsrv`) all the time and instead only synchronize the currently opened file to ServiceNow. This also fixes some issues, like the 0 Byte upload error AND a quite uncommon error, that the file watcher recognizes changes that aren't really there and pushes records to the current Update Set that shouldn't be in there.

Have a look at the file `.vscode/tasks.json` and check the command for `sync current file with ServiceNow` at first.
The task can be executed by pressing `F1` in Visual Studio Code and type `Tasks: Run Task` > `sync current file with ServiceNow`. 

If you want to bind this task to a hotkey, just press `F1` and type `Preferences: Open Keyboard Shortcuts File`, then insert (or add) the following to the opened file `Default Keybindings`:

```json
// Place your key bindings in this file to overwrite the defaults
[
    {
        "key": "ctrl+shift+s",
        "command": "workbench.action.tasks.runTask",
        "args": "sync current file with ServiceNow"
    }
]
```

So now you can execute the synchronizing by the selected hotkey.

## 5.2 Generate JSDoc for the currently opened File

### Prerequisites/Installation

In Visual Studio Code first install the extension "lit-it".
Then in the terminal run the following command: `npm install -g jsdoc`.

### Usage

In Javascript files you can now simply add JSDoc conform documentation by pressing `F1` and type `Lit it!` just in front of a function. This will result in the following, which you'll have to complete by yourself with the appropriate information:

```js
/**
 * @function myFancyFunction
 * @param  {type} someParam1 {description}
 * @param  {type} someParam2 {description}
 * @return {type} {description}
 */
function myFancyFunction(someParam1, someParam2) {
    return 'SomeString';
}
```

Have a look at the file `.vscode/tasks.json` and check the command for `create JSDoc for current file` at first.
The task can be executed by pressing `F1` in Visual Studio Code and type `Tasks: Run Task` > `create JSDoc for current file`. 

If you want to bind this task to a hotkey, just press `F1` and type `Preferences: Open Keyboard Shortcuts File`, then insert (or add) the following to the opened file `Default Keybindings`:

```json
// Place your key bindings in this file to overwrite the defaults
[
    {
        "key": "ctrl+shift+j",
        "command": "workbench.action.tasks.runTask",
        "args": "create JSDoc for current file"
    }
]
```