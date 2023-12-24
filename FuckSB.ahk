#SingleInstance Force
#Requires AutoHotkey >=2.0- <2.1 64-bit

TraySetIcon(A_WorkingDir . "\fucksb.ico")
global Name := "" ;被骂的名字
global Custom_Index := 1 ;自定义骂人库索引

; 读取骂人库，自定义骂人库内容，转换为字符串数组
txt := FileRead(A_WorkingDir . "\Data.txt")
txtArray := StrSplit(txt,"`n","`r")
custom_txt := FileRead(A_WorkingDir . "\Custom.txt")
custom_txt_array := StrSplit(custom_txt,"`n","`r")

#HotIf WinActive("ahk_exe League of Legends.exe") ;仅仅能在英雄联盟游戏对战界面使用
; 随机发送Data.txt库中的内容
F2::{
    global
    index := Random(1,txtArray.Length)
    SendInput("+{Enter}")
    Sleep(200)
    if(Name == ""){
        SendCn(txtArray[index])
    }
    else{
        SendCn(Name . "，" . txtArray[index])
    }
    Sleep(400)
    SendInput("{Enter}")
}

; 按照顺序发送Custom.txt库中内容
F3::{
    global
    SendInput("+{Enter}")
    Sleep(200)
    if(Name == ""){
        SendCn(custom_txt_array[Custom_Index])
    }
    else{
        SendCn(Name . "，" . custom_txt_array[Custom_Index])
    }
    Sleep(400)
    SendInput("{Enter}")
    if(Custom_Index < custom_txt_array.Length){
        Custom_Index := Custom_Index + 1
    }
    else{
        Custom_Index := 1
    }
}

; 获取被骂人姓名
F5::{
    global
    input_obj := InputBox("请输入您要骂的人的名字","名字")
    Name := input_obj.Value
}

; 重载脚本
F12::{
    Reload
}
#HotIf

/*
获取字符串的Unicode编码，使用Send发送Unicode编码，避免中文输入法的干扰问题返回值为字符串
str:字符串，需要发送的字符串
*/
SendCn(str)
{
    charList:=StrSplit(str)
    for key,val in charList{
        ; 转换每个字符为{U+16进制Unicode编码}
        out.="{U+" . Format("{:X}",ord(val)) . "}"
    }
    SendInput(out)
}