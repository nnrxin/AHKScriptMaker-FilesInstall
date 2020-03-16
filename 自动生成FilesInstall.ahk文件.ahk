;基础参数设置
#NoEnv
#NoTrayIcon    ;无托盘图标
#SingleInstance, Ignore    ;不能双开
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1  
SetControlDelay, -1
SendMode Input

;APP基础信息
global APP_NAME    := "自动生成InstallFile.ahk文件"    ;名称
global APP_VERSION := 1.1          ;版本
SetWorkingDir %A_ScriptDir%        ;工作目录设置为当前

;库:ini保存类
#Include <Class_IniSaved>
global INI := new IniSaved(APP_NAME "_config.ini")

;GUI界面
;~ Gui, +Resize +MinSize100x100  ;GUI可修改尺寸
Gui, Font,, 微软雅黑   ;字体修改
Gui, Color,, 0xCCE8CF   ;护眼绿色
/*
绿豆沙    #C7EDCC 或 #CCE8CF
银河白    #FFFFFF    
杏仁黄    #FAF9DE    
秋叶褐    #FFF2E2   
胭脂红    #FDE6E0   
青草绿    #E3EDCD   
海天蓝    #DCE2F1    
葛巾紫    #E9EBFE    
极光灰    #EAEAEF  
*/

Gui, Add, GroupBox, w600 h50, 文件夹路径(拖入文件)
Gui, Add, Edit, xp+10 yp+20 w580 h22 vini_GUI_ED0 ReadOnly, % INI.Init("GUI", "ED0", "")

Gui, Add, GroupBox, xm y+10 w600 h80, 参数设定
Gui, Add, text, xp+10 yp+22 w60 h22 Section, 函数名称:
Gui, Add, Edit, x+0 yp-2 w520 hp vini_GUI_ED1, % INI.Init("GUI", "ED1", "FileInstallTo")
Gui, Add, text, xs y+7 w60 h22, 文件名称:
Gui, Add, Edit, x+0 yp-2 w520 hp vini_GUI_ED2, % INI.Init("GUI", "ED2", "_InstallFile.ahk")

Gui, Add, Button, xm y+20 w600 h35 ggBT, 生成文件到本地

Gui, Add, StatusBar
Gui, Show,, % APP_NAME " v" APP_VERSION

;退出前运行
OnExit, RunBeforeExit
return    ;自动运行段结束######################################################################################################

;生成按键
gBT:
	Gui, Submit, NoHide
	if InStr(FileExist(vTargetPath),"D") and ini_GUI_ED1 and ini_GUI_ED2
	{
		if FileExist(A_ScriptDir "\" ini_GUI_ED2)
		{
			MsgBox, 4,, % ini_GUI_ED2 " 文件已存在,是否覆盖?", 30
			IfMsgBox Yes
			{
				SB_SetText("开始生成文件")
			}
			else
			{
				SB_SetText("取消生成文件")
				return
			}
		}
		txt := CreateFileInstall(vTargetPath, ini_GUI_ED1)
		FileDelete, % A_ScriptDir "\" ini_GUI_ED2
		FileAppend , % txt, % A_ScriptDir "\" ini_GUI_ED2, UTF-8
		SB_SetText("文件" ini_GUI_ED2 "已经生成")
	}
	else
		SB_SetText("无法生成")
return



;拖入文件夹
GuiDropFiles:
	GuiControl,, ini_GUI_ED0, % A_GuiEvent
return

;改变GUI尺寸时调整控件
GuiSize:
	;~ AutoXYWH("wh", "ini_GUI_ED1") 
return

;关闭GUI时退出
GuiClose:
ExitApp

;退出前运行
RunBeforeExit:
	Gui, Submit, NoHide
	INI.SaveAll()
ExitApp