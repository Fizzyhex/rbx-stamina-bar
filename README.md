# Stamina Bar

A simple, fully Luau typed stamina system demo for Roblox. 

Hold <kbd>Left Shift</kbd> to sprint! If the stamina bar runs out, you will be 'exhausted' and have to wait until it fills back up to sprint again.

![A demo showcasing the stamina bar](media/demo.gif)

## Installation

1. Clone the repository using [git](https://git-scm.com), or click 'Download ZIP' on the submenu that pops up when you click the green 'Code' button on GitHub.
```sh
git clone https://github.com/Fizzyhex/rbx-stamina-bar.git
```

2. Open up any Roblox place file and use [Rojo](https://rojo.space) to serve the project. This can be done via an IDE or by using the command-line tool.
```sh
rojo serve default.project.json
```

## Philosophy

The [`SprintUtil`](src/SprintSystem/SprintUtil.luau) module is hyper-focused on just managing the data that it needs. It effortlessly isn't dependent on Roblox libraries (such as RunService or ContextActionService) or even frameworks. Providing input and updating state is a responsibility that's passed off to the layer above - or [`SprintSystem`](src/SprintSystem/init.client.luau) in this case.