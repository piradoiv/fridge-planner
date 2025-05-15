#tag Class
Protected Class MealPlanManager
Implements iOSMobileTableDataSourceReordering
	#tag Method, Flags = &h21
		Private Function AllowRowMove(table As iOSMobileTable, section As Integer, row As Integer) As Boolean
		  // Part of the iOSMobileTableDataSourceReordering interface.
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mDB = New DatabaseManager
		  mDB.Connect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DuplicatePreviousMonth(year As Integer, month As Integer)
		  Var prevMonth As New DateTime(year, month - 1, 1)
		  Var prevPlans() As DailyPlan = mDB.GetPlansForMonth(prevMonth.Year, prevMonth.Month)
		  For Each plan As DailyPlan In prevPlans
		    Var newPlan As New DailyPlan
		    newPlan.PlanDate = New DateTime(year, month, plan.PlanDate.Day)
		    newPlan.Lunch = plan.Lunch
		    newPlan.Dinner = plan.Dinner
		    newPlan.Notes = plan.Notes
		    SavePlan(newPlan)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForDinner() As Meal()
		  Var result() As Meal
		  For Each meal As Meal In Meals
		    If meal.IsDinner Then result.Add(meal)
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForLunch() As Meal()
		  Var result() As Meal
		  For Each meal As Meal In Meals
		    If meal.IsLunch Then result.Add(meal)
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNextDayPlan(date As DateTime) As DailyPlan
		  Return GetPlanForDate(date.AddInterval(0, 0, 1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPlanForDate(date As DateTime) As DailyPlan
		  Var plans() As DailyPlan = mDB.GetPlansForMonth(date.Year, date.Month)
		  For Each plan As DailyPlan In plans
		    If plan.PlanDate.SQLDate = date.SQLDate Then
		      Return plan
		    End If
		  Next
		  
		  Var newPlan As New DailyPlan
		  newPlan.PlanDate = date
		  Return newPlan
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPreviousDayPlan(date As DateTime) As DailyPlan
		  Return GetPlanForDate(date.SubtractInterval(0, 0, 1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadPlansForMonth(year As Integer, month As Integer)
		  Self.Year = year
		  Self.Month = month
		  Plans = mDB.GetPlansForMonth(year, month)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MonthDayCount(year As Integer, month As Integer) As Integer
		  If month < 1 Or month > 12 Then
		    Return 0
		  End If
		  
		  Var d As DateTime = New DateTime(year, month, 1)
		  Var lastDay As DateTime = d.AddInterval(0, 1)
		  lastDay = lastDay.SubtractInterval(0, 0, lastDay.Day)
		  
		  Return lastDay.Day
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return MonthDayCount(Year, Month)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Var result As MobileTableCellData
		  Var plan As DailyPlan
		  For i As Integer = 0 To Plans.LastIndex
		    If Plans(i).PlanDate.Day = row + 1 Then
		      plan = Plans(i)
		      Exit For i
		    End If
		  Next
		  
		  If plan = Nil Then
		    Var day As New DateTime(Year, Month, row + 1)
		    result = table.CreateCell("-", day.SQLDate)
		    plan = New DailyPlan
		    plan.PlanDate = day
		  Else
		    result = table.CreateCell(plan.Lunch + " | " + plan.Dinner, plan.PlanDate.SQLDate + If(plan.Notes.Trim <> "", " " + plan.Notes, ""))
		  End If
		  
		  result.Tag = plan
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RowMoved(table As iOSMobileTable, sourceSection As Integer, sourceRow As Integer, destSection As Integer, destRow As Integer)
		  // Part of the iOSMobileTableDataSourceReordering interface.
		  
		  Break
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveMeal(meal As Meal)
		  For Each m As Meal In Meals
		    If m.Name = meal.Name And m.IsLunch = meal.IsLunch And m.IsDinner = meal.IsDinner Then
		      Return // Meal already exists
		    End If
		  Next
		  mDB.InsertMeal(meal)
		  Meals = mDB.GetAllMeals()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePlan(plan As DailyPlan)
		  If plan.Lunch <> "" Then
		    SaveMeal(New Meal(plan.Lunch, True, False))
		  End If
		  If plan.Dinner <> "" Then
		    SaveMeal(New Meal(plan.Dinner, False, True))
		  End If
		  If plan.ID = 0 Then
		    mDB.InsertPlan(plan)
		  Else
		    mDB.UpdatePlan(plan)
		  End If
		End Sub
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

	#tag Method, Flags = &h0
		Sub SwapMeals(day1 As DateTime, day2 As DateTime, isLunch As Boolean)
		  Var plan1, plan2 As DailyPlan
		  For Each plan As DailyPlan In Plans
		    If plan.PlanDate = day1 Then plan1 = plan
		    If plan.PlanDate = day2 Then plan2 = plan
		  Next
		  If plan1 = Nil Or plan2 = Nil Then Return
		  
		  If isLunch Then
		    Var temp As String = plan1.Lunch
		    plan1.Lunch = plan2.Lunch
		    plan2.Lunch = temp
		  Else
		    Var temp As String = plan1.Dinner
		    plan1.Dinner = plan2.Dinner
		    plan2.Dinner = temp
		  End If
		  SavePlan(plan1)
		  SavePlan(plan2)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mDB As DatabaseManager
	#tag EndProperty

	#tag Property, Flags = &h0
		Meals() As Meal
	#tag EndProperty

	#tag Property, Flags = &h0
		Month As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Plans() As DailyPlan
	#tag EndProperty

	#tag Property, Flags = &h0
		Year As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Month"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Year"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
