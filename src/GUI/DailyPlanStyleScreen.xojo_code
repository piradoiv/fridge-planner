#tag MobileScreen
Begin MobileScreen DailyPlanStyleScreen
   BackButtonCaption=   ""
   Compatibility   =   ""
   ControlCount    =   0
   Device = 1
   HasNavigationBar=   True
   LargeTitleDisplayMode=   2
   Left            =   0
   Orientation = 0
   ScaleFactor     =   0.0
   TabBarVisible   =   True
   TabIcon         =   0
   TintColor       =   &c000000
   Title           =   "Style"
   Top             =   0
   Begin MobileLabel BorderSizeLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   2
      AutoLayout      =   BorderSizeLabel, 4, BorderSizeTextField, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   BorderSizeLabel, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   BorderSizeLabel, 2, <Parent>, 9, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   BorderSizeLabel, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Border Size:"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   73
      Visible         =   True
      Width           =   120
      _ClosingFired   =   False
   End
   Begin MobileTextField BorderSizeTextField
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      AutoLayout      =   BorderSizeTextField, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   BorderSizeTextField, 1, BorderSizeLabel, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   BorderSizeTextField, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   BorderSizeTextField, 3, BorderSizeLabel, 3, False, +1.00, 4, 1, 0, , True
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   ""
      InputType       =   0
      Left            =   148
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      ReturnCaption   =   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   73
      Visible         =   True
      Width           =   152
      _ClosingFired   =   False
   End
   Begin MobileLabel BackgroundLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   2
      AutoLayout      =   BackgroundLabel, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   BackgroundLabel, 1, BorderSizeLabel, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   BackgroundLabel, 2, BorderSizeLabel, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   BackgroundLabel, 10, BackgroundRectangle, 10, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Background:"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   115
      Visible         =   True
      Width           =   120
      _ClosingFired   =   False
   End
   Begin MobileRectangle BackgroundRectangle
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   BackgroundRectangle, 8, BackgroundLabel, 8, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   BackgroundRectangle, 1, BackgroundLabel, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   BackgroundRectangle, 3, BorderSizeTextField, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   BackgroundRectangle, 7, BackgroundLabel, 8, False, +1.00, 4, 1, 0, , True
      BorderColor     =   CalendarBorderColor
      BorderThickness =   1.0
      ControlCount    =   0
      CornerSize      =   5.0
      Enabled         =   True
      FillColor       =   &cFFFFFF03
      Height          =   34
      Left            =   148
      LockedInPosition=   False
      Scope           =   2
      TintColor       =   &c000000
      Top             =   115
      Visible         =   True
      Width           =   34
      _ClosingFired   =   False
   End
   Begin MobileTextField BackgroundTextField
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      AutoLayout      =   BackgroundTextField, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   BackgroundTextField, 1, BackgroundRectangle, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   BackgroundTextField, 2, BorderSizeTextField, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   BackgroundTextField, 10, BackgroundRectangle, 10, False, +1.00, 4, 1, 0, , True
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   ""
      InputType       =   0
      Left            =   190
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      ReturnCaption   =   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "#00FFFFFF"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   115
      Visible         =   True
      Width           =   110
      _ClosingFired   =   False
   End
   Begin MobileColorPicker Picker
      HasAlpha        =   False
      Left            =   0
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   2
      Top             =   0
   End
   Begin MobileToolbarButton SaveButton
      Caption         =   "Untitled"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   272
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   3
      Width           =   40.0
   End
   Begin MobileToolbarButton ResetStyleButton
      Caption         =   "Reset style"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   8
      LockedInPosition=   False
      Scope           =   2
      Top             =   534
      Type            =   1001
      Width           =   77.0
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button
		  Case SaveButton
		    Plan.BackgroundColor = Color.FromString(BackgroundTextField.Text.Replace("#", "&h00"))
		    Plan.BorderSize = BorderSizeTextField.Text.ToInteger
		    App.MealsManager.SavePlan(Plan)
		    
		    Self.Close
		  Case ResetStyleButton
		    BackgroundTextField.Text = "#FFFFFF"
		    BorderSizeTextField.Text = "1"
		    BackgroundRectangle.FillColor = Color.White
		  End Select
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h21
		Private mPlan As DailyPlan
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mPlan
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPlan = value
			  
			  BackgroundRectangle.FillColor = value.BackgroundColor
			  BackgroundTextField.Text = value.BackgroundColor.ToString.Replace("&h00", "#")
			  BorderSizeTextField.Text = value.BorderSize.ToString
			End Set
		#tag EndSetter
		Plan As DailyPlan
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events BackgroundTextField
	#tag Event
		Sub FocusReceived()
		  Var c As Color = Color.FromString(Me.Text.Replace("&hFF", "&h00").Replace("#", "&h00"))
		  Picker.Show(c, "Background Color", Self, Me)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Picker
	#tag Event
		Sub ColorSelected(selectedColor As Color)
		  System.DebugLog(selectedColor.ToString)
		  
		  Var c As Color = selectedColor
		  BackgroundRectangle.FillColor = c
		  Var col As String = c.ToString.Replace("&h00", "#")
		  BackgroundTextField.Text = col
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue="-2147483648"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackButtonCaption"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasNavigationBar"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIcon"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Behavior"
		InitialValue="Untitled"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LargeTitleDisplayMode"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="MobileScreen.LargeTitleDisplayModes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Automatic"
			"1 - Always"
			"2 - Never"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabBarVisible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TintColor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ScaleFactor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Double"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
