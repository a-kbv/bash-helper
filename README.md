# Shell Script Menu Project

The Shell Script Menu Project is a command-line interface (CLI) structured in a series of directories and subdirectories, each of which contains a suite of shell script tools designed to perform a variety of different tasks. 

The main script, `main.sh`, serves as a gateway to the rest of the scripts in the project. It presents the user with a list of all available directories or tools, excluding specified directories. The user can then input the number corresponding to the tool they wish to use, which will run the corresponding script.

Each tool directory contains another `main.sh` script, which further categorizes the tools available within its own directory and presents them as options to the user. Each of these tools is a shell script file located in the "lib" subdirectory of the tool directory. When the tool is selected, the corresponding shell script is run.

## Usage

1. Navigate to the root directory containing main.sh script.
2. Execute the main script using the command `./main.sh`.
3. You will be presented with a menu of available tools. Enter the number of your preferred tool.
4. You will then get another menu for subtools within the selected tool. Again, enter the number of your selection.
5. The selected tool runs. Press any key to return to the tools menu.
6. Repeat above steps to run other tools. Enter the corresponding number to "Exit" or "Return" when you are finished.

## Customization

To add your own tools to the project, you can copy the provided `Example` directory, rename it, and replace or modify the scripts within it.

The directory structure should look like this:

```bash
└── YourTool
    ├── lib
    │   └── your_script.sh
    └── main.sh
```

To start, just copy the `Example` directory in the root of the project:

```bash
cp -r Example YourTool
```

Replace `YourTool` with the name of your tool. Inside the `lib` directory, rename `example.sh` to `your_script.sh` or whatever fits the purpose of the script.

Then, open `your_script.sh` in your preferred text editor and write your own script.

Finally, open `main.sh` and update any reference to `Example` or `example.sh` to match the new name of your tool and script.

This will create a new custom tool in the main script menu.

Please note, the `Example` directory is excluded from the main script menu by design. Any new directories you add will be automatically included in the menu unless explicitly excluded in `main.sh`.

Ensure that all the scripts in the `lib` directory have execute permissions:

```bash
chmod +x YourTool/lib/*
```

Now your custom tool will be available when the shell script menu is run.

## Integration into .bashrc

You can add this tool to your `.bashrc` file for easy execution from any terminal location. Here's the step-by-step guide:

**Step 1: Open your .bashrc file**

Open a terminal and type:

```bash
cd
nano ~/.bashrc
```
This will open your bashrc file in nano text editor.

**Step 2: Add an alias**

At the bottom of the file, on a new line, add an alias for your script. If your `main.sh` script is located in `/home/username/ShellScriptMenuProject/main.sh`, add the following alias:

```bash
alias helper='/home/username/ShellScriptMenuProject/main.sh'

```

You can replace `helper` with any name you prefer to call your tool from the terminal.

**Step 3: Save changes and update Bash**

Press `Ctrl+X` to quit nano, press `Y` to save the changes and `Enter` to confirm. Then, to refresh your terminal environment with the updated `.bashrc` settings, type:

```bash
source ~/.bashrc
```

Your script is now available as a command you can run from any location in your terminal. Just type `helper` (or whatever alias you set) and your shell script menu will start.

**Note**: You should ensure that `main.sh` has the appropriate execute permissions (`chmod +x main.sh`) for the alias to run properly. 

***


### Note

Ensure that all shell script files have correct permissions set to allow execution. Otherwise, the scripts will not run correctly when selected from the menu.

## Conclusion

This project provides a simple and intuitive way of managing and executing a large collection of shell scripts. By categorically structuring and automatically populating shell script menus, it eases the interface for users, making it more manageable and user-friendly.