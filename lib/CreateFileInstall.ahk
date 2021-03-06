﻿;生成安装文件的ahk代码,返回字串
CreateFileInstall(path, functionName := "FileInstallTo")
{
	if not InStr(FileExist(path), "D")
		return
	BatchLines := A_BatchLines 
	SetBatchLines, -1
	pathLength := StrLen(path)
	files := []
	folders := [""]
	;获取源path内全部文件信息
	Loop, Files, % path "\*", FDR
	{
		subPath := SubStr(A_LoopFilePath, pathLength + 1)
		if InStr(FileExist(A_LoopFilePath), "D")
			folders.push(subPath)
		else
			files.push(subPath)
	}
	;先只保留互不包含的目录
	match := {}
	for i, m in folders
	{
		for j, n in folders
		{
			if (i <> j) and instr("\/" m, "\/" n)
				match[j] := 1
		}
	}
	for i in match
		folders.Delete(i)
	MsgBox % match.count()
	
	;开始
	t := ";安装文件函数`r`n" functionName "(targetPath, cover := 0)`r`n{`r`n"

	;先创建文件夹
	t .= "`t;创建文件夹`r`n"
	for i, v in folders
		t .= "`tFileCreateDir, % targetPath """ v """`r`n"
	
	;再安装文件
	t .= "`t;安装文件`r`n"
	for i, v in files
		t .= "`tFileInstall, " path . v ", % targetPath """ v """, % cover`r`n"
	
	;结尾
	t .= "}"
	
	SetBatchLines, %BatchLines%
	return t
}