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
		  "plan_id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "plan_date TEXT UNIQUE, " + _
		  "lunch TEXT, " + _
		  "dinner TEXT, " + _
		  "notes TEXT)")
		  DB.ExecuteSQL("CREATE TABLE IF NOT EXISTS meals (" + _
		  "meal_id INTEGER PRIMARY KEY AUTOINCREMENT, " + _
		  "meal_name TEXT NOT NULL, " + _
		  "is_lunch INTEGER, " + _
		  "is_dinner INTEGER)")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAllMeals() As Meal()
		  Var result() As Meal
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM meals")
		  For Each row As DatabaseRow In rs
		    Var meal As New Meal
		    meal.ID = row.Column("meal_id").IntegerValue
		    meal.Name = row.Column("meal_name").StringValue
		    meal.IsLunch = row.Column("is_lunch").IntegerValue = 1
		    meal.IsDinner = row.Column("is_dinner").IntegerValue = 1
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
		  For Each row As DatabaseRow In rs
		    Var plan As New DailyPlan
		    plan.ID = row.Column("plan_id").IntegerValue
		    plan.PlanDate = DateTime.FromString(row.Column("plan_date").StringValue)
		    plan.Lunch = row.Column("lunch").StringValue
		    plan.Dinner = row.Column("dinner").StringValue
		    plan.Notes = row.Column("notes").StringValue
		    result.Add(plan)
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertMeal(meal As Meal)
		  Const SQL = "INSERT INTO meals (meal_name, is_lunch, is_dinner) VALUES (?, ?, ?)"
		  DB.ExecuteSQL(SQL, meal.Name, meal.IsLunch, meal.IsDinner)
		  meal.ID = DB.LastRowID
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPlan(plan As DailyPlan)
		  Const SQL = "INSERT INTO plans (plan_date, lunch, dinner, notes) VALUES (?, ?, ?, ?)"
		  DB.ExecuteSQL(SQL, plan.PlanDate.SQLDate, plan.Lunch, plan.Dinner, plan.Notes)
		  plan.ID = DB.LastRowID
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlan(plan As DailyPlan)
		  Var sql As String = "UPDATE plans SET lunch = ?, dinner = ?, notes = ? WHERE plan_id = ?"
		  DB.ExecuteSQL(sql, plan.Lunch, plan.Dinner, plan.Notes, plan.ID)
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
