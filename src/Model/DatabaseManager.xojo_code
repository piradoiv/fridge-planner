#tag Class
Protected Class DatabaseManager
	#tag Method, Flags = &h0
		Sub Connect()
		  DB = New SQLiteDatabase
		  // Get the Documents folder
		  Var documents As FolderItem = SpecialFolder.Documents
		  // Create a subfolder with the app's bundle identifier
		  Var appFolder As FolderItem = documents.Child("es.rcruz.fridgeplanner")
		  If Not appFolder.Exists Then
		    appFolder.CreateFolder
		  End If
		  // Store the database in the subfolder
		  DB.DatabaseFile = appFolder.Child("FridgePlanner.db")
		  
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
		  
		  DB.ExecuteSQL("CREATE TABLE IF NOT EXISTS migrations (version INTEGER NOT NULL)")
		  
		  Var indexes() As String
		  indexes.Add("CREATE INDEX idx_is_lunch ON meals (is_lunch)")
		  indexes.Add("CREATE INDEX idx_is_dinner ON meals (is_dinner)")
		  indexes.Add("CREATE INDEX idx_is_lunch_dinner ON meals (is_lunch, is_dinner)")
		  indexes.Add("CREATE INDEX idx_name ON meals (name)")
		  indexes.Add("CREATE INDEX idx_plan_id_meal_id ON plans_meals (plan_id, meal_id)")
		  
		  #Pragma BreakOnExceptions False
		  For Each indexDefinition As String In indexes
		    Try
		      DB.ExecuteSQL(indexDefinition)
		    Catch ex As DatabaseException
		      // Ignore
		    End Try
		  Next
		  
		  RunMigrations
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteMealPlan(mealPlanID As Integer)
		  Var planIDs() As Integer
		  Var rs As RowSet = DB.SelectSQL("SELECT id FROM plans WHERE meal_plan_id = ?", mealPlanID)
		  For Each row As DatabaseRow In rs
		    planIDs.Add(row.Column("id").IntegerValue)
		  Next
		  For Each pid As Integer In planIDs
		    DB.ExecuteSQL("DELETE FROM plans_meals WHERE plan_id = ?", pid)
		  Next
		  DB.ExecuteSQL("DELETE FROM plans WHERE meal_plan_id = ?", mealPlanID)
		  DB.ExecuteSQL("DELETE FROM meal_plans WHERE id = ?", mealPlanID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetActiveMealPlan() As MealPlan
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM meal_plans WHERE is_active = 1 LIMIT 1")
		  For Each row As DatabaseRow In rs
		    Var mp As New MealPlan
		    mp.ID = row.Column("id").IntegerValue
		    mp.UUID = row.Column("uuid").StringValue
		    mp.Name = row.Column("name").StringValue
		    mp.IsActive = True
		    Return mp
		  Next
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAllMealPlans() As MealPlan()
		  Var result() As MealPlan
		  Var rs As RowSet = DB.SelectSQL("SELECT * FROM meal_plans ORDER BY name")
		  For Each row As DatabaseRow In rs
		    Var mp As New MealPlan
		    mp.ID = row.Column("id").IntegerValue
		    mp.UUID = row.Column("uuid").StringValue
		    mp.Name = row.Column("name").StringValue
		    mp.IsActive = row.Column("is_active").BooleanValue
		    result.Add(mp)
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAllMeals() As Meal()
		  #If LogQueries
		    System.DebugLog(CurrentMethodName)
		  #EndIf
		  
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

	#tag Method, Flags = &h21
		Private Function GetLastMigrationIndex() As Integer
		  Var rows As RowSet = DB.SelectSQL("SELECT version FROM migrations")
		  
		  For Each row As DatabaseRow In rows
		    Return row.Column("version").IntegerValue
		  Next
		  
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMealsForDinner() As Meal()
		  #If LogQueries
		    System.DebugLog(CurrentMethodName)
		  #EndIf
		  
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
		  #If LogQueries
		    System.DebugLog(CurrentMethodName)
		  #EndIf
		  
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
		Function GetPlansForMonth(year As Integer, month As Integer, day As Integer = -1, mealPlanID As Integer = 0) As DailyPlan()
		  #If LogQueries
		    System.DebugLog(CurrentMethodName + " year " + year.ToString + " month " + month.ToString + " day " + day.ToString)
		  #EndIf
		  
		  Var result() As DailyPlan
		  
		  Var firstDay As String = If(day > 0, day.ToString(Nil, "00"), "01")
		  Var lastDay As String = If(day > 0, day.ToString(Nil, "00"), "31")
		  
		  Var startDate As String = year.ToString + "-" + month.ToString(Nil, "00") + "-" + firstDay
		  Var endDate As String = year.ToString + "-" + month.ToString(Nil, "00") + "-" + lastDay
		  
		  Var sql As String = "SELECT * FROM plans WHERE plan_date BETWEEN ? AND ?"
		  Var rs As RowSet
		  If mealPlanID > 0 Then
		    sql = sql + " AND meal_plan_id = ?"
		    rs = DB.SelectSQL(sql, startDate, endDate, mealPlanID)
		  Else
		    rs = DB.SelectSQL(sql, startDate, endDate)
		  End If
		  
		  For Each planRow As DatabaseRow In rs
		    Var plan As New DailyPlan
		    plan.ID = planRow.Column("id").IntegerValue
		    plan.PlanDate = DateTime.FromString(planRow.Column("plan_date").StringValue)
		    plan.Notes = planRow.Column("notes").StringValue
		    plan.MealPlanID = planRow.Column("meal_plan_id").IntegerValue
		    Var c As String = planRow.Column("background_color").StringValue
		    If c = "FFFFFF" Then
		      plan.BackgroundColor = Color.White
		    Else
		      plan.BackgroundColor = Color.FromString("&c" + c)
		    End If
		    plan.BorderSize = planRow.Column("border_size").IntegerValue
		    
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
		Function GetSyncMetadata(mealPlanUUID As String) As Dictionary
		  Var result As New Dictionary
		  Var rows As RowSet = DB.SelectSQL("SELECT cloudkit_record_id, last_synced_at FROM sync_metadata WHERE meal_plan_uuid = ?", mealPlanUUID)
		  If rows <> Nil And Not rows.AfterLastRow Then
		    result.Value("cloudkit_record_id") = rows.Column("cloudkit_record_id").StringValue
		    result.Value("last_synced_at") = rows.Column("last_synced_at").StringValue
		  End If
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetUnsyncedMealPlans() As MealPlan()
		  Var result() As MealPlan
		  Var rows As RowSet = DB.SelectSQL("SELECT mp.id, mp.uuid, mp.name, mp.is_active, mp.created_at, mp.modified_at " + _
		  "FROM meal_plans mp LEFT JOIN sync_metadata sm ON mp.uuid = sm.meal_plan_uuid " + _
		  "WHERE sm.meal_plan_uuid IS NULL OR mp.modified_at > sm.last_synced_at " + _
		  "ORDER BY mp.created_at ASC")
		  If rows = Nil Then Return result
		  While Not rows.AfterLastRow
		    Var plan As New MealPlan
		    plan.ID = rows.Column("id").IntegerValue
		    plan.UUID = rows.Column("uuid").StringValue
		    plan.Name = rows.Column("name").StringValue
		    plan.IsActive = rows.Column("is_active").IntegerValue = 1
		    result.Add(plan)
		    rows.MoveToNextRow
		  Wend
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertMeal(meal As Meal)
		  #Pragma BreakOnExceptions False
		  
		  #If LogQueries
		    System.DebugLog(CurrentMethodName + " meal " + meal.Name)
		  #EndIf
		  
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
		Sub InsertMealPlan(mealPlan As MealPlan)
		  DB.ExecuteSQL("INSERT INTO meal_plans (uuid, name, is_active, created_at, modified_at) VALUES (?, ?, ?, ?, ?)", _
		  mealPlan.UUID, mealPlan.Name, If(mealPlan.IsActive, 1, 0), _
		  mealPlan.CreatedAt.SQLDateTime, mealPlan.ModifiedAt.SQLDateTime)
		  mealPlan.ID = DB.LastRowID
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPlan(plan As DailyPlan)
		  #If LogQueries
		    System.DebugLog(CurrentMethodName + " date " + plan.PlanDate.SQLDate)
		  #EndIf
		  
		  Const SQL = "INSERT INTO plans (plan_date, notes, background_color, border_size, meal_plan_id) VALUES (?, ?, ?, ?, ?)"
		  DB.ExecuteSQL(SQL, plan.PlanDate.SQLDate, plan.Notes, plan.BackgroundColor.ToString.Replace("&h00", ""), plan.BorderSize, plan.MealPlanID)
		  plan.ID = DB.LastRowID
		  
		  UpdatePlanMeals(plan)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveOrphanMeals()
		  #If LogQueries
		    System.DebugLog(CurrentMethodName)
		  #EndIf
		  
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

	#tag Method, Flags = &h21
		Private Sub RunMigrations()
		  Var migrations() As String
		  Var migration() As String
		  
		  // Add background_color to plans
		  migration.Add("PRAGMA foreign_keys = 0")
		  migration.Add("CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM plans")
		  migration.Add("DROP TABLE plans")
		  migration.Add("CREATE TABLE plans (id INTEGER PRIMARY KEY AUTOINCREMENT, plan_date TEXT UNIQUE, notes TEXT, background_color VARCHAR (8) DEFAULT [00FFFFFF])")
		  migration.Add("INSERT INTO plans (id, plan_date, notes) SELECT id, plan_date, notes FROM sqlitestudio_temp_table")
		  migration.Add("DROP TABLE sqlitestudio_temp_table")
		  migration.Add("PRAGMA foreign_keys = 1")
		  
		  migrations.Add(String.FromArray(migration, ";"))
		  migration.RemoveAll
		  
		  // Add border_size to plans
		  migration.Add("PRAGMA foreign_keys = 0")
		  migration.Add("CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM plans")
		  migration.Add("DROP TABLE plans")
		  migration.Add("CREATE TABLE plans (id INTEGER PRIMARY KEY AUTOINCREMENT, plan_date TEXT UNIQUE, notes TEXT, background_color VARCHAR (8) DEFAULT [00FFFFFF], border_size INTEGER DEFAULT 1)")
		  migration.Add("INSERT INTO plans (id, plan_date, notes) SELECT id, plan_date, notes FROM sqlitestudio_temp_table")
		  migration.Add("DROP TABLE sqlitestudio_temp_table")
		  migration.Add("PRAGMA foreign_keys = 1")
		  
		  migrations.Add(String.FromArray(migration, ";"))
		  migration.RemoveAll
		  
		  // Add meal_plans table, meal_plan_id to plans, seed default plan
		  migration.Add("CREATE TABLE meal_plans (id INTEGER PRIMARY KEY AUTOINCREMENT, uuid TEXT UNIQUE NOT NULL, name TEXT NOT NULL, is_active INTEGER DEFAULT 0, created_at TEXT NOT NULL, modified_at TEXT NOT NULL)")
		  migration.Add("CREATE INDEX idx_meal_plans_uuid ON meal_plans (uuid)")
		  migration.Add("ALTER TABLE plans ADD COLUMN meal_plan_id INTEGER")
		  migration.Add("CREATE INDEX idx_meal_plan_id ON plans (meal_plan_id)")
		  migration.Add("INSERT INTO meal_plans (uuid, name, is_active, created_at, modified_at) VALUES (" + _
		  "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || " + _
		  "substr(lower(hex(randomblob(2))),2) || '-' || " + _
		  "substr('89ab', abs(random()) % 4 + 1, 1) || " + _
		  "substr(lower(hex(randomblob(2))),2) || '-' || " + _
		  "lower(hex(randomblob(6))), " + _
		  "'My Meal Plan', 1, datetime('now'), datetime('now'))")
		  migration.Add("UPDATE plans SET meal_plan_id = (SELECT id FROM meal_plans WHERE is_active = 1)")
		  
		  migrations.Add(String.FromArray(migration, ";"))
		  migration.RemoveAll
		  
		  // Add sync_metadata table for CloudKit sync state
		  migration.Add("CREATE TABLE sync_metadata (meal_plan_uuid TEXT PRIMARY KEY, cloudkit_record_id TEXT, last_synced_at TEXT)")
		  
		  migrations.Add(String.FromArray(migration, ";"))
		  migration.RemoveAll
		  
		  For i As Integer = GetLastMigrationIndex To migrations.LastIndex - 1
		    DB.ExecuteSQL(migrations(i + 1))
		    DB.ExecuteSQL("DELETE FROM migrations")
		    DB.ExecuteSQL("INSERT INTO migrations (version) VALUES (?)", i + 1)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveSyncMetadata(mealPlanUUID As String, cloudkitRecordID As String)
		  DB.ExecuteSQL("INSERT INTO sync_metadata (meal_plan_uuid, cloudkit_record_id, last_synced_at) VALUES (?, ?, datetime('now')) " + _
		  "ON CONFLICT(meal_plan_uuid) DO UPDATE SET cloudkit_record_id = excluded.cloudkit_record_id, last_synced_at = excluded.last_synced_at", _
		  mealPlanUUID, cloudkitRecordID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetActiveMealPlan(mealPlanID As Integer)
		  DB.ExecuteSQL("UPDATE meal_plans SET is_active = 0")
		  DB.ExecuteSQL("UPDATE meal_plans SET is_active = 1 WHERE id = ?", mealPlanID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateMealPlan(mealPlan As MealPlan)
		  mealPlan.ModifiedAt = DateTime.Now
		  DB.ExecuteSQL("UPDATE meal_plans SET name = ?, is_active = ?, modified_at = ? WHERE id = ?", _
		  mealPlan.Name, If(mealPlan.IsActive, 1, 0), mealPlan.ModifiedAt.SQLDateTime, mealPlan.ID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlan(plan As DailyPlan)
		  #If LogQueries
		    System.DebugLog(CurrentMethodName + " plan date " + plan.PlanDate.SQLDate)
		  #EndIf
		  
		  Var sql As String = "UPDATE plans SET notes = ?, background_color = ?, border_size = ? WHERE id = ?"
		  DB.ExecuteSQL(sql, plan.Notes, plan.BackgroundColor.ToString().Replace("&h00", ""), plan.BorderSize, plan.ID)
		  
		  UpdatePlanMeals(plan)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlanMeals(plan As DailyPlan)
		  #If LogQueries
		    System.DebugLog(CurrentMethodName + " plan date " + plan.PlanDate.SQLDate)
		  #EndIf
		  
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


	#tag Constant, Name = LogQueries, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant


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
