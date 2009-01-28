DeclareDLL Main_Open()
DeclareDLL PBParams_Open()

;@desc Opens the main window for Moebius
ProcedureDLL Main_Open()
  If OpenWindow(#Window_0, 353, 5, 600, 503, "Moebius",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_WindowCentered )
    Frame3DGadget(#Frame3D_0, 10, 10, 580, 70, "Etape 1 : Purebasic")
      TextGadget(#Text_0, 80, 40, 40, 20, "Etat : ")
      ButtonGadget(#Button_0, 450, 30, 130, 40, "Configurer")
      TextGadget(#Text_1, 250, 30, 100, 40, "NOK", #PB_Text_Center)
        SetGadgetFont(#Text_1, FontID)
        SetGadgetColor(#Text_1, #PB_Gadget_FrontColor, RGB(255, 0, 0))
    
    Frame3DGadget(#Frame3D_1, 10, 90, 580, 240, "Etape 2 : Configuration du projet")
      CheckBoxGadget(#CheckBox_0, 30, 110, 250, 20, "Mode Unicode")
      CheckBoxGadget(#CheckBox_1, 330, 110, 250, 20, "Mode Threadsafe")
      CheckBoxGadget(#CheckBox_2, 30, 140, 250, 20, "Générer un fichier Batch")
      CheckBoxGadget(#CheckBox_3, 330, 140, 250, 20, "Générer un fichier Log")
      CheckBoxGadget(#CheckBox_4, 30, 170, 290, 20, "Ne pas compiler la librairie, seulement les fichiers sources")
      CheckBoxGadget(#CheckBox_5, 330, 170, 250, 20, "Effacer les fichiers sources aprés compilation")
      
      TextGadget(#Text_2, 30, 200, 120, 20, "Nom de la librairie")
      StringGadget(#String_0, 160, 200, 330, 20, "")
      
      TextGadget(#Text_3, 30, 230, 120, 20, "Fichier Source :")
      StringGadget(#String_1, 160, 230, 330, 20, "")
      ButtonGadget(#Button_1, 500, 230, 80, 20, "Parcourir")
      
      TextGadget(#Text_4, 30, 260, 120, 20, "Fichier Aide :")
      StringGadget(#String_2, 160, 260, 330, 20, "")
      ButtonGadget(#Button_2, 500, 260, 80, 20, "Parcourir")
      
      TextGadget(#Text_5, 30, 290, 120, 20, "Sous-système :")
      ComboBoxGadget(#Combo_0, 160, 290, 330, 20)

    Frame3DGadget(#Frame3D_2, 10, 340, 580, 150, "Etape 3 : Compilation du projet")
      EditorGadget(#Editor_0, 20, 390, 560, 90)
      ButtonGadget(#Button_3, 20, 360, 110, 20, "Compiler")
  EndIf
EndProcedure
;@desc Set Purebasic params
ProcedureDLL PBParams_Open()
  If OpenWindow(#Window_1, 488, 98, 520, 200, "Moebius : PureBasic",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
    TextGadget(#Text_6, 10, 10, 110, 20, "Dossier Purebasic :", #PB_Text_Center)
    StringGadget(#String_3, 130, 10, 260, 20, "")
    ButtonGadget(#Button_4, 400, 10, 80, 20, "Parcourir")
    TextGadget(#Text_7, 490, 10, 20, 20, "")
      SetGadgetColor(#Text_7, #PB_Gadget_BackColor, RGB(255, 0, 0))

    TextGadget(#Text_8, 10, 40, 110, 20, "Compilateur :", #PB_Text_Center)
    StringGadget(#String_4, 130, 40, 260, 20, "")
    ButtonGadget(#Button_5, 400, 40, 80, 20, "Parcourir")
    TextGadget(#Text_9, 490, 40, 20, 20, "")
      SetGadgetColor(#Text_9, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Text_10, 10, 70, 110, 20, "Fasm :", #PB_Text_Center)
    StringGadget(#String_5, 130, 70, 260, 20, "")
    ButtonGadget(#Button_6, 400, 70, 80, 20, "Parcourir")
    TextGadget(#Text_11, 490, 70, 20, 20, "")
      SetGadgetColor(#Text_11, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Text_12, 10, 100, 110, 20, "Obj2Lib :", #PB_Text_Center)
    StringGadget(#String_6, 130, 100, 260, 20, "")
    ButtonGadget(#Button_7, 400, 100, 80, 20, "Parcourir")
    TextGadget(#Text_13, 490, 100, 20, 20, "")
      SetGadgetColor(#Text_13, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    TextGadget(#Text_14, 10, 130, 110, 20, "LibMaker :", #PB_Text_Center)
    StringGadget(#String_7, 130, 130, 260, 20, "")
    ButtonGadget(#Button_8, 400, 130, 80, 20, "Parcourir")
    TextGadget(#Text_15, 490, 130, 20, 20, "")
      SetGadgetColor(#Text_15, #PB_Gadget_BackColor, RGB(255, 0, 0))
    
    ButtonGadget(#Button_9, 320, 160, 90, 30, "Valider")
    ButtonGadget(#Button_10, 420, 160, 90, 30, "Fermer")
  EndIf
EndProcedure
