#tag MobileScreen
Begin MobileScreen EditDailyPlanScreen Implements iOSMobileTableDataSource
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
   Begin Timer UpdatePlanTimer
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Period          =   1000
      RunMode         =   0
      Scope           =   2
   End
   Begin iOSMobileTable DayPlanTable
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   DayPlanTable, 4, BottomLayoutGuide, 3, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 2, <Parent>, 2, False, +1.00, 4, 1, -0, , True
      AutoLayout      =   DayPlanTable, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
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
End
#tag EndMobileScreen

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub DoUpdatePlan()
		  UpdatePlanTimer.RunMode = Timer.RunModes.Off
		  
		  Break
		  Plan.Lunch.RemoveAll
		  // Plan.Lunch.Add(New Meal(LunchTextField.Text.Trim))
		  Plan.Dinner.RemoveAll
		  // Plan.Dinner.Add(New Meal(DinnerTextField.Text.Trim))
		  // Plan.Notes = NotesTextArea.Text.Trim
		  
		  If Plan.ID = 0 And Plan.Lunch.Count = 0 And Plan.Dinner.Count = 0 And Plan.Notes = "" Then
		    Return
		  End If
		  
		  RaiseEvent UpdatePlanRequested
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return 3
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Var cell As MobileTableCellData
		  
		  Select Case row
		  Case 0
		    cell = table.CreateCell("Lunch", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    Var meals() As String
		    For Each meal As Meal In Plan.Lunch
		      meals.Add(meal.Name)
		    Next
		    
		    cell.DetailText = String.FromArray(meals, ", ")
		  Case 1
		    cell = table.CreateCell("Dinner", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    Var meals() As String
		    For Each meal As Meal In Plan.Dinner
		      meals.Add(meal.Name)
		    Next
		    
		    cell.DetailText = String.FromArray(meals, ", ")
		  Case 2
		    cell = table.CreateCell("Notes", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		  End Select
		  
		  Return cell
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SectionCount(table As iOSMobileTable) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SectionTitle(table As iOSMobileTable, section As Integer) As String
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdatePlan()
		  UpdatePlanTimer.RunMode = Timer.RunModes.Single
		End Sub
	#tag EndMethod


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
			  DayPlanTable.ReloadDataSource
			  
			  // LunchTextField.Text = If(value.Lunch.Count > 0, value.Lunch(0).Name, "")
			  // DinnerTextField.Text = If(value.Dinner.Count > 0, value.Dinner(0).Name, "")
			  // NotesTextArea.Text = value.Notes
			End Set
		#tag EndSetter
		Plan As DailyPlan
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events UpdatePlanTimer
	#tag Event
		Sub Run()
		  DoUpdatePlan
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DayPlanTable
	#tag Event
		Sub Opening()
		  Me.DataSource = Self
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  Var titles() As String = Array("Lunch", "Dinner", "Notes")
		  
		  Var s As New EditMealsScreen
		  s.Title = titles(row)
		  s.Plan = Plan
		  s.Show(Self)
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
