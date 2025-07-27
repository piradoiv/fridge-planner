#tag Class
Protected Class MealPlanManager
	#tag Method, Flags = &h0
		Sub Constructor()
		  mDB = New DatabaseManager
		  mDB.Connect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoMaintenance()
		  mDB.RemoveOrphanMeals
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
		Function GetAllMeals() As Meal()
		  Var temp As New Dictionary
		  
		  For Each meal As Meal In GetMealsForLunch
		    If Not temp.HasKey(meal.ID) Then
		      temp.Value(meal.ID) = meal
		    End If
		  Next
		  For Each meal As Meal In GetMealsForDinner
		    If Not temp.HasKey(meal.ID) Then
		      temp.Value(meal.ID) = meal
		    End If
		  Next
		  
		  Var result() As Meal
		  For Each entry As DictionaryEntry In temp
		    result.Add(entry.Value)
		  Next
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForDinner() As Meal()
		  Return mDB.GetMealsForDinner
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForLunch() As Meal()
		  Return mDB.GetMealsForLunch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNextDayPlan(date As DateTime) As DailyPlan
		  Return GetPlanForDate(date.AddInterval(0, 0, 1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPlanForDate(date As DateTime) As DailyPlan
		  Static plansDate As String = ""
		  Static plans() As DailyPlan
		  
		  If plansDate <> date.SQLDate Then
		    plansDate = date.SQLDate
		    plans = mDB.GetPlansForMonth(date.Year, date.Month, date.Day)
		  End If
		  
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

	#tag Method, Flags = &h0
		Sub SaveMeal(meal As Meal)
		  mDB.InsertMeal(meal)
		  Meals = mDB.GetAllMeals()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePlan(plan As DailyPlan)
		  For Each lunch As Meal In plan.Lunch
		    If lunch.ID = 0 Then
		      SaveMeal(lunch)
		    End If
		  Next
		  
		  For Each dinner As Meal In plan.Dinner
		    If dinner.ID = 0 Then
		      SaveMeal(dinner)
		    End If
		  Next
		  
		  If plan.ID = 0 Then
		    mDB.InsertPlan(plan)
		  Else
		    mDB.UpdatePlan(plan)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SwapMeals(day1 As DateTime, day2 As DateTime, isLunch As Boolean)
		  Var plan1, plan2 As DailyPlan
		  For Each plan As DailyPlan In Plans
		    If plan.PlanDate = day1 Then plan1 = plan
		    If plan.PlanDate = day2 Then plan2 = plan
		  Next
		  If plan1 = Nil Or plan2 = Nil Then Return
		  
		  Break
		  // If isLunch Then
		  // Var temp As String = plan1.Lunch
		  // plan1.Lunch = plan2.Lunch
		  // plan2.Lunch = temp
		  // Else
		  // Var temp As String = plan1.Dinner
		  // plan1.Dinner = plan2.Dinner
		  // plan2.Dinner = temp
		  // End If
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
