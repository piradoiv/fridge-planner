#tag MobileScreen
Begin MobileScreen MainScreen
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
   Begin MealPlanManager MealPlans
      Left            =   0
      LockedInPosition=   False
      Month           =   0
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   2
      Top             =   0
      Year            =   0
   End
   Begin iOSMobileTable PlansTable
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   PlansTable, 4, BottomLayoutGuide, 3, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   PlansTable, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   PlansTable, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   PlansTable, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   2
      Height          =   503
      Left            =   0
      LockedInPosition=   False
      Scope           =   2
      SectionCount    =   0
      TintColor       =   &c000000
      Top             =   65
      Visible         =   True
      Width           =   320
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
   Begin MobileToolbarButton NextMonthButton
      Caption         =   "Next"
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
   Begin MobileToolbarButton PreviousMonthButton
      Caption         =   "Previous"
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
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  CurrentDate = DateTime.Now
		  CurrentDate = CurrentDate.SubtractInterval(0, 0, CurrentDate.Day - 1)
		  
		  LoadPlans
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button
		  Case NextMonthButton
		    CurrentDate = CurrentDate.AddInterval(0, 1)
		    CurrentDate = CurrentDate.SubtractInterval(0, 0, CurrentDate.Day - 1)
		  Case PreviousMonthButton
		    CurrentDate = CurrentDate.SubtractInterval(0, 0, 1)
		    CurrentDate = CurrentDate.SubtractInterval(0, 0, CurrentDate.Day - 1)
		  End Select
		  
		  LoadPlans
		  PlansTable.ScrollToRow(0)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub EditScreenClosingHandler(sender As EditDailyPlanScreen)
		  Var plan As DailyPlan = sender.Plan
		  If plan = Nil Or (plan.PlanDate.Year = CurrentDate.Year And plan.PlanDate.Month = CurrentDate.Month) Then
		    Return
		  End If
		  
		  CurrentDate = New DateTime(plan.PlanDate.Year, plan.PlanDate.Month, 1)
		  LoadPlans
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EditScreenToolbarButtonPressedHandler(sender As MobileScreen, button As MobileToolbarButton)
		  Var editScreen As EditDailyPlanScreen = EditDailyPlanScreen(sender)
		  Var plan As DailyPlan = editScreen.Plan
		  If plan = Nil Then
		    Return
		  End If
		  
		  Select Case button.Type
		  Case MobileToolbarButton.Types.Rewind
		    editScreen.Plan = MealPlans.GetPreviousDayPlan(plan.PlanDate)
		  Case MobileToolbarButton.Types.FastForward
		    editScreen.Plan = MealPlans.GetNextDayPlan(plan.PlanDate)
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadPlans()
		  Self.Title = CurrentDate.ToString("YYYY-MM")
		  MealPlans.LoadPlansForMonth(CurrentDate.Year, CurrentDate.Month)
		  PlansTable.ReloadDataSource
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdatePlanRequestedHandler(sender As EditDailyPlanScreen)
		  MealPlans.SavePlan(sender.Plan)
		  LoadPlans
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CurrentDate As DateTime
	#tag EndProperty


#tag EndWindowCode

#tag Events PlansTable
	#tag Event
		Sub Opening()
		  Me.DataSource = MealPlans
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  Var cell As MobileTableCellData = Me.RowCellData(section, row)
		  Var plan As DailyPlan = DailyPlan(cell.Tag)
		  plan = MealPlans.GetPlanForDate(plan.PlanDate)
		  cell.Tag = plan
		  
		  Var s As New EditDailyPlanScreen
		  AddHandler s.ToolbarButtonPressed, WeakAddressOf EditScreenToolbarButtonPressedHandler
		  AddHandler s.UpdatePlanRequested, WeakAddressOf UpdatePlanRequestedHandler
		  AddHandler s.Closing, WeakAddressOf EditScreenClosingHandler
		  s.Plan = plan
		  s.ShowModal(Self)
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
