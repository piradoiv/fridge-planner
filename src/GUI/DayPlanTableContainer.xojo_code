#tag MobileContainer
Begin MobileContainer DayPlanTableContainer Implements iOSMobileTableDataSourceEditing
   AccessibilityHint=   ""
   AccessibilityLabel=   ""
   Compatibility   =   ""
   Device = 7
   Height          =   238
   Left            =   0
   Orientation = 0
   Top             =   0
   Visible         =   True
   Width           =   320
   Begin iOSMobileTable DayPlanTable
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   DayPlanTable, 4, <Parent>, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 3, <Parent>, 3, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
      Height          =   238
      Left            =   0
      LockedInPosition=   False
      Scope           =   2
      SectionCount    =   0
      TintColor       =   &c000000
      Top             =   0
      Visible         =   True
      Width           =   320
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
End
#tag EndMobileContainer

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub AddMealHandler(sender As AddMealScreen, mealName As String)
		  Var meal As New Meal(mealName)
		  meal.IsLunch = sender.IsLunch
		  meal.IsDinner = Not sender.IsLunch
		  
		  If meal.IsLunch Then
		    plan.Lunch.Add(meal)
		  Else
		    plan.Dinner.Add(meal)
		  End If
		  
		  App.MealsManager.SavePlan(plan)
		  
		  RaiseEvent ReloadRequested
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AllowRowEditing(table As iOSMobileTable, section As Integer, row As Integer) As Boolean
		  // Part of the iOSMobileTableDataSourceEditing interface.
		  
		  Select Case section
		  Case 0
		    Return row <= Plan.Lunch.LastIndex
		  Case 1
		    Return row <= Plan.Dinner.LastIndex
		  Case 2
		    Return row = 0
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reload()
		  DayPlanTable.ReloadDataSource
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Select Case section
		  Case 0
		    Return If(Plan = Nil, 1, Plan.Lunch.Count + 1)
		  Case 1
		    Return If(Plan = Nil, 1, Plan.Dinner.Count + 1)
		  Case 2
		    Return 3
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Var cell As MobileTableCellData
		  
		  Select Case section
		  Case 0
		    If row > Plan.Lunch.LastIndex Then
		      Return table.CreateCell("Add meal", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    End If
		    
		    Var meal As Meal = Plan.Lunch(row)
		    cell = table.CreateCell(meal.Name)
		  Case 1
		    If row > Plan.Dinner.LastIndex Then
		      Return table.CreateCell("Add meal", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    End If
		    
		    Var meal As Meal = Plan.Dinner(row)
		    cell = table.CreateCell(meal.Name)
		  Case 2
		    Select Case row
		    Case 0
		      cell = table.CreateCell("Edit Notes", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    Case 1
		      cell = table.CreateCell("Edit Style", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    Case 2
		      cell = table.CreateCell("Swap meals with another day", "", Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    End Select
		  End Select
		  
		  Return cell
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RowEditingCompleted(table As iOSMobileTable, section As Integer, row As Integer, action As iOSMobileTable.RowEditingStyles)
		  // Part of the iOSMobileTableDataSourceEditing interface.
		  
		  Select Case section
		  Case 0
		    Plan.Lunch.RemoveAt(row)
		  Case 1
		    Plan.Dinner.RemoveAt(row)
		  End Select
		  
		  App.MealsManager.SavePlan(Plan)
		  
		  RaiseEvent ReloadRequested
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SectionCount(table As iOSMobileTable) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return 3
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SectionTitle(table As iOSMobileTable, section As Integer) As String
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Var titles() As String = Array("Lunch", "Dinner", "Day Actions")
		  Return titles(section)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TriggerReload(sender As MobileScreen)
		  RaiseEvent ReloadRequested
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ReloadRequested()
	#tag EndHook


	#tag Property, Flags = &h0
		Plan As DailyPlan
	#tag EndProperty


#tag EndWindowCode

#tag Events DayPlanTable
	#tag Event
		Sub Opening()
		  Me.DataSource = Self
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  
		  Select Case section
		  Case 0
		    Var s As New AddMealScreen
		    AddHandler s.AddMeal, WeakAddressOf AddMealHandler
		    If row > Plan.Lunch.LastIndex Then
		      s.IsLunch = True
		      s.ShowModal(MobileScreen(App.CurrentLayout.Content))
		    End If
		  Case 1
		    Var s As New AddMealScreen
		    AddHandler s.AddMeal, WeakAddressOf AddMealHandler
		    If row > Plan.Dinner.LastIndex Then
		      s.IsLunch = False
		      s.ShowModal(MobileScreen(App.CurrentLayout.Content))
		    End If
		  Case 2
		    Select Case row
		    Case 0
		      Break
		    Case 1
		      Var s As New DailyPlanStyleScreen
		      AddHandler s.Closing, WeakAddressOf TriggerReload
		      s.Plan = Plan
		      s.Show(MobileScreen(App.CurrentLayout.Content))
		    Case 2
		      Break
		    End Select
		  End Select
		End Sub
	#tag EndEvent
	#tag Event
		Function ApplyRowEditingStyle(section As Integer, row As Integer) As iOSMobileTable.RowEditingStyles
		  Return iOSMobileTable.RowEditingStyles.Delete
		End Function
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="TintColor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
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
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AccessibilityHint"
		Visible=false
		Group="UI Control"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AccessibilityLabel"
		Visible=false
		Group="UI Control"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="UI Control"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="UI Control"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=false
		Group=""
		InitialValue="320"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=false
		Group=""
		InitialValue="480"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
