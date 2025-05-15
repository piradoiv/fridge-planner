#tag MobileScreen
Begin MobileScreen EditDailyPlanScreen
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
   Title           =   "Untitled"
   Top             =   0
   Begin MobileButton CloseButton
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   CloseButton, 9, <Parent>, 9, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   CloseButton, 7, , 0, False, +1.00, 4, 1, 100, , True
      AutoLayout      =   CloseButton, 4, <Parent>, 4, False, +1.00, 4, 1, -*kStdGapCtlToViewV, , True
      AutoLayout      =   CloseButton, 8, , 0, False, +1.00, 4, 1, 30, , True
      Caption         =   "Done"
      CaptionColor    =   &c007AFF00
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   110
      LockedInPosition=   False
      Scope           =   2
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   518
      Visible         =   True
      Width           =   100
      _ClosingFired   =   False
   End
   Begin MobileToolbarButton PreviousButton
      Caption         =   "Untitled"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   8
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   19
      Width           =   22.0
   End
   Begin MobileToolbarButton NextButton
      Caption         =   "Untitled"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   290
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   20
      Width           =   22.0
   End
   Begin MobileLabel LunchLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AutoLayout      =   LunchLabel, 8, , 0, False, +1.00, 4, 1, 30, , True
      AutoLayout      =   LunchLabel, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   LunchLabel, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   LunchLabel, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Lunch"
      TextColor       =   &c000000
      TextFont        =   "System Bold		"
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   73
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileTextField LunchTextField
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      AutoLayout      =   LunchTextField, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   LunchTextField, 1, LunchLabel, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   LunchTextField, 2, LunchLabel, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   LunchTextField, 3, LunchLabel, 4, False, +1.00, 4, 1, 0, , True
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   ""
      InputType       =   0
      Left            =   20
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
      Top             =   103
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileLabel DinnerLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AutoLayout      =   DinnerLabel, 1, LunchTextField, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DinnerLabel, 2, LunchTextField, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DinnerLabel, 3, LunchTextField, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   DinnerLabel, 8, , 0, False, +1.00, 4, 1, 30, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Dinner"
      TextColor       =   &c000000
      TextFont        =   "System Bold		"
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   145
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileTextField DinnerTextField
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      AutoLayout      =   DinnerTextField, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   DinnerTextField, 1, DinnerLabel, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DinnerTextField, 2, DinnerLabel, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DinnerTextField, 3, DinnerLabel, 4, False, +1.00, 4, 1, 0, , True
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   ""
      InputType       =   0
      Left            =   20
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
      Top             =   175
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileLabel NotesLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AutoLayout      =   NotesLabel, 1, DinnerTextField, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   NotesLabel, 2, DinnerTextField, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   NotesLabel, 3, DinnerTextField, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   NotesLabel, 8, , 0, False, +1.00, 4, 1, 30, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Notes"
      TextColor       =   &c000000
      TextFont        =   "System Bold		"
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   217
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileTextArea NotesTextArea
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      AutoLayout      =   NotesTextArea, 4, CloseButton, 3, False, +1.00, 4, 1, -*kStdControlGapV, , True
      AutoLayout      =   NotesTextArea, 1, NotesLabel, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   NotesTextArea, 2, NotesLabel, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   NotesTextArea, 3, NotesLabel, 4, False, +1.00, 4, 1, 0, , True
      BorderStyle     =   0
      ControlCount    =   0
      Enabled         =   True
      Height          =   263
      Left            =   20
      LockedInPosition=   False
      maximumCharactersAllowed=   0
      ReadOnly        =   False
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   247
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin Timer UpdatePlanTimer
      Height          =   32
      Height          =   32
      Left            =   220
      Left            =   220
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Period          =   1000
      RunMode         =   0
      Scope           =   2
      Top             =   220
      Top             =   220
      Width           =   32
      Width           =   32
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  LunchTextField.SetFocus
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  DoUpdatePlan
		  RaiseEvent ToolbarButtonPressed(button)
		  
		  LunchTextField.SetFocus
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub DoUpdatePlan()
		  UpdatePlanTimer.RunMode = Timer.RunModes.Off
		  
		  Plan.Lunch = LunchTextField.Text.Trim
		  Plan.Dinner = DinnerTextField.Text.Trim
		  Plan.Notes = NotesTextArea.Text.Trim
		  
		  If Plan.ID = 0 And Plan.Lunch = "" And Plan.Dinner = "" And Plan.Notes = "" Then
		    Return
		  End If
		  
		  RaiseEvent UpdatePlanRequested
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdatePlan()
		  UpdatePlanTimer.RunMode = Timer.RunModes.Single
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ToolbarButtonPressed(button As MobileToolbarButton)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event UpdatePlanRequested()
	#tag EndHook


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
			  Title = value.PlanDate.SQLDate
			  LunchTextField.Text = value.Lunch
			  DinnerTextField.Text = value.Dinner
			  NotesTextArea.Text = value.Notes
			End Set
		#tag EndSetter
		Plan As DailyPlan
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events CloseButton
	#tag Event
		Sub Pressed()
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LunchTextField
	#tag Event
		Sub TextChanged()
		  UpdatePlan
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DinnerTextField
	#tag Event
		Sub TextChanged()
		  UpdatePlan
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events NotesTextArea
	#tag Event
		Sub TextChanged()
		  UpdatePlan
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events UpdatePlanTimer
	#tag Event
		Sub Run()
		  DoUpdatePlan
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
