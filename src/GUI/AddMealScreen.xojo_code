#tag MobileScreen
Begin MobileScreen AddMealScreen Implements iOSMobileTableDataSource
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
   Title           =   "Add meal"
   Top             =   0
   Begin MobileLabel MealNameLabel
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AutoLayout      =   MealNameLabel, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   MealNameLabel, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   MealNameLabel, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   MealNameLabel, 8, , 0, False, +1.00, 4, 1, 30, , True
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
      Text            =   "Meal name:"
      TextColor       =   &c000000
      TextFont        =   "System Bold		"
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   73
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileTextField MealNameTextField
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   True
      AutoCapitalizationType=   0
      AutoLayout      =   MealNameTextField, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   MealNameTextField, 1, MealNameLabel, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   MealNameTextField, 2, MealNameLabel, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   MealNameTextField, 3, MealNameLabel, 4, False, +1.00, 4, 1, 0, , True
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
      ReturnCaption   =   9
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
   Begin MobileToolbarButton CancelButton
      Caption         =   "Untitled"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   8
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   1
      Width           =   52.0
   End
   Begin iOSMobileTable SuggestionsTable
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   SuggestionsTable, 4, BottomLayoutGuide, 3, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   SuggestionsTable, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   SuggestionsTable, 2, <Parent>, 2, False, +1.00, 4, 1, -0, , True
      AutoLayout      =   SuggestionsTable, 3, MealNameTextField, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
      Height          =   423
      Left            =   0
      LockedInPosition=   False
      Scope           =   2
      SectionCount    =   0
      TintColor       =   &c000000
      Top             =   145
      Visible         =   True
      Width           =   320
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  Reload
		  MealNameTextField.SetFocus
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button
		  Case SaveButton
		    Var mealName As String = MealNameTextField.Text.Trim
		    If mealName <> "" Then
		      RaiseEvent AddMeal(mealName)
		    End If
		  End Select
		  
		  Self.Close
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Reload()
		  Meals.RemoveAll
		  
		  Var mealName As String = MealNameTextField.Text.Trim
		  For Each meal As Meal In App.MealsManager.GetAllMeals
		    If mealName = "" Or meal.Name.Contains(mealName) Then
		      Meals.Add(meal)
		    End If
		  Next
		  
		  SuggestionsTable.ReloadDataSource
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return Meals.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Part of the iOSMobileTableDataSource interface.
		  
		  If row > Meals.LastIndex Then
		    Return Nil
		  End If
		  
		  Return table.CreateCell(Meals(row).Name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SectionCount(table As iOSMobileTable) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SectionTitle(table As iOSMobileTable, section As Integer) As String
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return ""
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AddMeal(mealName As String)
	#tag EndHook


	#tag Property, Flags = &h0
		IsLunch As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			App.MealsManager.GetAllMeals
		#tag EndNote
		Private Meals() As Meal
	#tag EndProperty


#tag EndWindowCode

#tag Events MealNameTextField
	#tag Event
		Sub TextChanged()
		  Reload
		End Sub
	#tag EndEvent
	#tag Event
		Function ReturnPressed() As Boolean
		  RaiseEvent AddMeal(Me.Text.Trim)
		  Self.Close
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events SuggestionsTable
	#tag Event
		Sub Opening()
		  Me.DataSource = Self
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  RaiseEvent AddMeal(Me.RowCellData(row).Text)
		  Self.Close
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
	#tag ViewProperty
		Name="IsLunch"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
