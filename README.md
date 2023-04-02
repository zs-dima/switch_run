# Run command depends on shortcut pressed at startup.

### Helps to automate Total Commander toolbar buttons with click + shortcuts.


```bash
switch-run.exe -h
switch-run.exe -a notepad.exe text.txt -r notepad++.exe text.txt
```

```
-r, --run           Run command when no shortcut key is pressed
-a, --alt           Run command when Alt is pressed
-c, --ctrl          Run command when Ctrl is pressed
-s, --shift         Run command when Shift is pressed
-w, --win           Run command when Win is pressed
-f, --folder        Default path to run command in
-p, --parameters    Parameters to pass to the shortcut command
-b, --before        Run command before running the shortcut command
-t, --after         Run command after running the shortcut command
-h, --[no-]help     Help
```
