# FreeCADCT 编译记录（macOS arm64）

## 结论
FreeCADCT 已在 `FreeCADCT/` 下用官方 pixi 流程编译成功，Release 版可运行。

## 环境
- 机器：macOS 26.3.1 / arm64 (Apple Silicon)，8 核 / 16 GB
- 工具链：pixi 0.80.0（conda-forge 包，未装 conda/miniforge）
  - 安装位置：`~/.pixi/bin/pixi`
  - 说明：GitHub Release 下载极慢，改用 `https://conda.anaconda.org/conda-forge/osx-arm64/pixi-0.80.0-*.conda` 解包得到二进制
- conda 依赖环境：`FreeCADCT/.pixi/envs/default`（约 4.1 GB）
  - Python 3.11.14 / Qt 6.8.3 / PySide6 6.8.3 / OCCT 7.8.1 / Coin3D 4.0.10 / VTK 9.3.1 / SMESH 9.8.0.2
  - clang 18.1.8（conda 自带），CMake 4.2.3，Ninja

## 编译步骤
```bash
cd FreeCADCT
~/.pixi/bin/pixi run configure-release   # cmake --preset conda-macos-release
~/.pixi/bin/pixi run build-release       # cmake --build build/release
~/.pixi/bin/pixi run install-release     # 安装到 .pixi/envs/default
```

## 结果
- 编译目标 8250 个，全部完成，退出码 0，无 error
- 源码版本：`7b97df6e98`（origin: github.com/JackBlogs/FreeCADCT.git, main）
- 版本串：`FreeCAD 26.3.0 Revision: 48679 (Git)`
- 构建目录 `build/release`（约 1.1 GB），日志 `/tmp/fcct-configure.log`、`/tmp/fcct-build.log`

## 验证
- `FreeCADCmd --version` → `FreeCAD 26.3.0 Revision: 48679 (Git)`
- 无界面功能测试：`Part.makeBox(10,20,30).Volume` = 6000.0；箱体-圆柱布尔切割成功；Part/Sketcher/Mesh/Draft/TechDraw 模块均可导入
- GUI 启动测试（`QT_QPA_PLATFORM=offscreen`）进程正常常驻，无崩溃

## 运行方式
```bash
cd FreeCADCT
./run-freecad.sh                 # 图形界面
./run-freecad.sh 模型.FCStd      # 打开文件
FREECAD_BIN=FreeCADCmd ./run-freecad.sh 脚本.py   # 无界面跑脚本
```
也可直接用 `FreeCADCT/.pixi/envs/default/bin/FreeCAD`，或 `pixi run freecad-release`。

## 备注
- 当前 `FREECAD_CREATE_MAC_APP=OFF`，产出的是命令行可执行文件，不是 `FreeCAD.app` 应用包。
  如需可双击的 .app：`pixi run configure-release -- -DFREECAD_CREATE_MAC_APP=ON` 后重新 build。
- 新增/修改 C++ 代码后只需 `pixi run build-release && pixi run install-release`；纯 Python 工作台（如 `~/.local/share/FreeCAD/Mod` 或 `~/Library/Application Support/FreeCAD/Mod`）无需重编。
- 环境内已带 ccache，重复编译会明显更快。
