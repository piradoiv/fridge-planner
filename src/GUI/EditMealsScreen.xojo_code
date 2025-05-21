#tag MobileScreen
Begin MobileScreen EditMealsScreen Implements iOSMobileTableDataSource
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
   Begin iOSMobileTable MealsTable
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   MealsTable, 4, BottomLayoutGuide, 3, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   MealsTable, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   MealsTable, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   MealsTable, 3, SelectedMealsLabel, 4, False, +1.00, 4, 1, 30, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
      Height          =   393
      Left            =   0
      LockedInPosition=   False
      Scope           =   2
      SectionCount    =   0
      TintColor       =   &c000000
      Top             =   175
      Visible         =   True
      Width           =   320
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
   Begin MobileToolbarButton AddMealButton
      Caption         =   "Untitled"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   290
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   4
      Width           =   22.0
   End
   Begin MobileLabel SelectedMealsLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   1
      AutoLayout      =   SelectedMealsLabel, 8, , 0, False, +1.00, 4, 1, 50, , True
      AutoLayout      =   SelectedMealsLabel, 1, MealsTable, 1, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   SelectedMealsLabel, 2, MealsTable, 2, False, +1.00, 4, 1, -*kStdControlGapH, , True
      AutoLayout      =   SelectedMealsLabel, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 30, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   50
      Left            =   8
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Selected: -"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   95
      Visible         =   True
      Width           =   304
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  Reload
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button
		  Case AddMealButton
		    Var s As New AddMealScreen
		    AddHandler s.AddMeal, WeakAddressOf AddMealHandler
		    s.ShowModal(Self)
		  End Select
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AddMealHandler(sender As AddMealScreen, mealName As String)
		  Var newMeal As New Meal(mealName)
		  newMeal.IsLunch = Title = "Lunch"
		  newMeal.IsDinner = Title = "Dinner"
		  App.MealsManager.SaveMeal(newMeal)
		  
		  If newMeal.IsLunch Then
		    Plan.Lunch.Add(newMeal)
		  ElseIf newMeal.IsDinner Then
		    Plan.Dinner.Add(newMeal)
		  End If
		  App.MealsManager.SavePlan(Plan)
		  
		  Reload
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Reload()
		  Select Case Title
		  Case "Lunch"
		    Meals = App.MealsManager.GetMealsForLunch
		  Case "Dinner"
		    Meals = App.MealsManager.GetMealsForDinner
		  End Select
		  
		  If Search <> "" Then
		    For i As Integer = Meals.LastIndex DownTo 0
		      If Not Meals(i).Name.Contains(Search) Then
		        Meals.RemoveAt(i)
		      End If
		    Next
		  End If
		  
		  Meals.Sort(WeakAddressOf SortMealsByName)
		  MealsTable.ReloadDataSource
		  
		  Var mealNames() As String
		  For Each meal As Meal In If(Title = "Lunch", Plan.Lunch, Plan.Dinner)
		    mealNames.Add(meal.Name)
		  Next
		  mealNames.Sort
		  
		  SelectedMealsLabel.Text = "Selected: " + String.FromArray(mealNames, ", ")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return Meals.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Var cell As MobileTableCellData = table.CreateCell(Meals(row).Name)
		  Var planMeals() As Meal = If(Title = "Lunch", Plan.Lunch, Plan.Dinner)
		  
		  For Each m As Meal In planMeals
		    If m.Name = Meals(row).Name Then
		      cell.AccessoryType = MobileTableCellData.AccessoryTypes.Checkmark
		      Exit For
		    End If
		  Next
		  
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
		Private Function SortMealsByName(value1 As Meal, value2 As Meal) As Integer
		  Return value1.Name.Compare(value2.Name)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Meals() As Meal
	#tag EndProperty

	#tag Property, Flags = &h0
		Plan As DailyPlan
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Search As String
	#tag EndProperty


#tag EndWindowCode

#tag Events MealsTable
	#tag Event
		Sub Opening()
		  Me.DataSource = Self
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  Var mealName As String = Me.RowCellData(row).Text
		  
		  Var found As Boolean = False
		  Var meals() As Meal = If(Title = "Lunch", Plan.Lunch, Plan.Dinner)
		  For i As Integer = meals.LastIndex DownTo 0
		    If meals(i).Name = mealName Then
		      meals.RemoveAt(i)
		      found = True
		    End If
		  Next
		  
		  If Not found Then
		    Var newMeal As New Meal(mealName)
		    newMeal.IsLunch = Title = "Lunch"
		    newMeal.IsDinner = Title = "Dinner"
		    meals.Add(newMeal)
		  End If
		  
		  If Title = "Lunch" Then
		    Plan.Lunch = meals
		  ElseIf Title = "Dinner" Then
		    Plan.Dinner = meals
		  End If
		  
		  App.MealsManager.SavePlan(Plan)
		  Reload
		End Sub
	#tag EndEvent
	#tag Event
		Sub SearchChanged(value As String)
		  Search = value.Trim
		  Reload
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
