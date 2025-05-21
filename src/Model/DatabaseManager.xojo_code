#tag Class
Protected Class DatabaseManager
	#tag Method, Flags = &h0
		Sub Connect()
		  DB = New SQLiteDatabase
		  // Get the Documents folder
		  Var documents As FolderItem = SpecialFolder.Documents
		  // Create a subfolder with the app's bundle identifier
		  Var appFolder As FolderItem = documents.Child("es.rcruz.mealplanner")
		  If Not appFolder.Exists Then
		    appFolder.CreateFolder
		  End If
		  // Store the database in the subfolder
		  DB.DatabaseFile = appFolder.Child("MealPlanner.db")
		  
		  #If DebugBuild
		    System.DebugLog("DB File: " + DB.DatabaseFile.NativePath)
		    If DB.DatabaseFile.Exists Then
		      // DB.DatabaseFile.Remove
		    End If
		  #EndIf
		  
		  If Not DB.DatabaseFile.Exists Then
		    DB.CreateDatabase
		  End If
		  
		  If Not DB.Connect Then
		    Raise New DatabaseException("Could not connect to database")
		  End If
		  CreateTables()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateTables()
		  DB.ExecuteSQL("CREATE TABLE IF NOT EXISTS plans (" + _
		  "id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "plan_date TEXT UNIQUE, " + _
		  "notes TEXT)")
		  
		  DB.ExecuteSQL("CREATE TABLE IF NOT EXISTS meals (" + _
		  "id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "is_lunch INTEGER, " + _
		  "is_dinner INTEGER, " + _
		  "name TEXT UNIQUE NOT NULL)")
		  
		  DB.ExecuteSQL("CREATE TABLE IF NOT EXISTS plans_meals (" + _
		  "plan_id INTEGER NOT NULL, " + _
		  "meal_id INTEGER NOT NULL, " + _
		  "is_lunch INTEGER, " + _
		  "is_dinner INTEGER, " + _
		  "FOREIGN KEY (plan_id) REFERENCES plans (id), " + _
		  "FOREIGN KEY (meal_id) REFERENCES meals (id))")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAllMeals() As Meal()
		  Var result() As Meal
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM meals")
		  For Each row As DatabaseRow In rs
		    Var meal As New Meal
		    meal.ID = row.Column("id").IntegerValue
		    meal.Name = row.Column("name").StringValue
		    meal.IsLunch = row.Column("is_lunch").BooleanValue
		    meal.IsDinner = row.Column("is_dinner").BooleanValue
		    result.Add(meal)
		  Next
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForDinner() As Meal()
		  Var result() As Meal
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM meals WHERE is_dinner = 1")
		  For Each row As DatabaseRow In rs
		    Var meal As New Meal
		    meal.ID = row.Column("id").IntegerValue
		    meal.Name = row.Column("name").StringValue
		    meal.IsLunch = row.Column("is_lunch").BooleanValue
		    meal.IsDinner = row.Column("is_dinner").BooleanValue
		    result.Add(meal)
		  Next
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForLunch() As Meal()
		  Var result() As Meal
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM meals WHERE is_lunch = 1")
		  For Each row As DatabaseRow In rs
		    Var meal As New Meal
		    meal.ID = row.Column("id").IntegerValue
		    meal.Name = row.Column("name").StringValue
		    meal.IsLunch = row.Column("is_lunch").BooleanValue
		    meal.IsDinner = row.Column("is_dinner").BooleanValue
		    result.Add(meal)
		  Next
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPlansForMonth(year As Integer, month As Integer) As DailyPlan()
		  Var result() As DailyPlan
		  Var startDate As String = year.ToString + "-" + month.ToString(Nil, "00") + "-01"
		  Var endDate As String = year.ToString + "-" + month.ToString(Nil, "00") + "-31"
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM plans WHERE plan_date BETWEEN ? AND ?", startDate, endDate)
		  For Each planRow As DatabaseRow In rs
		    Var plan As New DailyPlan
		    plan.ID = planRow.Column("id").IntegerValue
		    plan.PlanDate = DateTime.FromString(planRow.Column("plan_date").StringValue)
		    plan.Notes = planRow.Column("notes").StringValue
		    
		    Var mealsRS As RowSet = DB.SelectSQL("SELECT plans_meals.*, meals.name FROM plans_meals JOIN meals ON meals.id = plans_meals.meal_id WHERE plan_id = ? GROUP BY meal_id", plan.ID)
		    For Each mealRow As DatabaseRow In mealsRS
		      If mealRow.Column("is_lunch").BooleanValue Then
		        Var meal As New Meal(mealRow.Column("name"))
		        meal.ID = mealRow.Column("meal_id").IntegerValue
		        plan.Lunch.Add(meal)
		      End If
		      If mealRow.Column("is_dinner").BooleanValue Then
		        Var meal As New Meal(mealRow.Column("name"))
		        meal.ID = mealRow.Column("meal_id").IntegerValue
		        plan.Dinner.Add(meal)
		      End If
		    Next
		    
		    result.Add(plan)
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertMeal(meal As Meal)
		  #Pragma BreakOnExceptions False
		  If meal.Name.Trim = "" Then
		    Return
		  End If
		  
		  Try
		    Var sql As String = "INSERT INTO meals (name, is_lunch, is_dinner) VALUES (?, ?, ?)"
		    DB.ExecuteSQL(SQL, meal.Name, meal.IsLunch, meal.IsDinner)
		    meal.ID = DB.LastRowID
		  Catch ex As DatabaseException
		    Var rows As RowSet = DB.SelectSQL("SELECT id FROM meals WHERE name = ? LIMIT 1", meal.Name)
		    For Each row As DatabaseRow In rows
		      meal.ID = row.Column("id").IntegerValue
		    Next
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPlan(plan As DailyPlan)
		  Const SQL = "INSERT INTO plans (plan_date, notes) VALUES (?, ?)"
		  DB.ExecuteSQL(SQL, plan.PlanDate.SQLDate, plan.Notes)
		  plan.ID = DB.LastRowID
		  
		  UpdatePlanMeals(plan)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveOrphanMeals()
		  Const SQL = "SELECT meals.id " + _
		  "FROM meals " + _
		  "LEFT JOIN plans_meals ON meals.id = plans_meals.meal_id " +_
		  "WHERE plans_meals.meal_id IS NULL"
		  
		  Var rows As RowSet = DB.SelectSQL(SQL)
		  For Each row As DatabaseRow In rows
		    DB.ExecuteSQL("DELETE FROM meals WHERE id = ?", row.Column("id").IntegerValue)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlan(plan As DailyPlan)
		  Var sql As String = "UPDATE plans SET notes = ? WHERE id = ?"
		  DB.ExecuteSQL(sql, plan.Notes, plan.ID)
		  
		  UpdatePlanMeals(plan)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlanMeals(plan As DailyPlan)
		  // Remove relationships before adding the new ones
		  DB.ExecuteSQL("DELETE FROM plans_meals WHERE plan_id = ?", plan.ID)
		  
		  Var meals() As Meal
		  
		  For Each meal As Meal In plan.Lunch
		    If meal.ID = 0 Then
		      InsertMeal(meal)
		    End If
		    meal.IsLunch = True
		    meals.Add(meal)
		  Next
		  
		  For Each meal As Meal In plan.Dinner
		    Var found As Boolean
		    For i As Integer = 0 To meals.LastIndex
		      If meals(i).Name = meal.Name Then
		        meals(i).IsDinner = True
		        found = True
		      End If
		    Next
		    
		    If Not found Then
		      If meal.ID = 0 Then
		        InsertMeal(meal)
		      End If
		      meal.IsDinner = True
		      meals.Add(meal)
		    End If
		  Next
		  
		  For Each meal As Meal In meals
		    DB.ExecuteSQL("INSERT INTO plans_meals (plan_id, meal_id, is_lunch, is_dinner) VALUES (?, ?, ?, ?)", plan.ID, meal.ID, meal.IsLunch, meal.IsDinner)
		    DB.ExecuteSQL("UPDATE meals SET is_lunch = ?, is_dinner = ? WHERE id = ?", meal.IsLunch, meal.IsDinner, meal.ID)
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private DB As SQLiteDatabase
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
	#tag EndViewBehavior
End Class
#tag EndClass
