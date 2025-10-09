#tag Class
Protected Class App
Inherits MobileApplication
	#tag CompatibilityFlags = TargetIOS
	#tag Event
		Sub LowMemoryWarning()
		  //Add a breadcrumb for LowMemoryWarning
		  
		  Var message As String
		  Var ObjectCount As Integer
		  Var memoryUsed As Integer
		  
		  ObjectCount  = Runtime.ObjectCount
		  MemoryUsed  = Round(Runtime.MemoryUsed / 10000) / 100
		  
		  message = "ObjectCount: " + ObjectCount.ToString + EndOfLine + _
		  "MemoryUsed: " + memoryUsed.ToString + " MB"
		  
		  If App.Sentry <> Nil Then
		    App.Sentry.AddBreadcrumb("info", CurrentMethodName, Xojo_Sentry.errorLevel.warning, _
		    New Dictionary("ObjectCount": ObjectCount, "MemoryUsed": memoryUsed.ToString + " MB"))
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  InitializeSentry
		  
		  MealsManager = New MealPlanManager
		  
		  #If False And DebugBuild
		    For i As Integer = 0 To 10
		      Var d As New DateTime(2025, 1, 1)
		      d = d.AddInterval(0, 0, i)
		      Var plan As DailyPlan = MealsManager.GetPlanForDate(d)
		      If plan.Lunch.Count = 0 Then
		        Var lunches As String = kLunchMeals
		        Var lines() As String = lunches.Split(EndOfLine)
		        lines.Shuffle
		        For j As Integer = 0 To 9
		          plan.Lunch.Add(New Meal(lines(j)))
		        Next
		        MealsManager.SavePlan(plan)
		      End If
		      
		      If plan.Dinner.Count = 0 Then
		        Var dinners As String = kDinnerMeals
		        Var lines() As String = dinners.Split(EndOfLine)
		        lines.Shuffle
		        For j As Integer = 0 To 9
		          plan.Dinner.Add(New Meal(lines(j)))
		        Next
		        MealsManager.SavePlan(plan)
		      End If
		    Next
		  #EndIf
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(exc As RuntimeException) As Boolean
		  #If DebugBuild
		    Var reason As String
		    reason = exc.Message
		  #EndIf
		  
		  //Exception
		  Try
		    #If DebugBuild
		      App.Sentry.SubmitException(exc, "", "", Xojo_Sentry.errorLevel.debug)
		    #Else
		      App.Sentry.SubmitException(exc, "", "", Xojo_Sentry.errorLevel.error)
		    #EndIf
		    
		    //Make sure we do not create another exception by sending it to Sentry
		  Catch err
		    
		  End Try
		  
		  MessageBox("A fatal error just happened, but the app will continue running. If the problem persists, contact support.")
		  
		  //Return true to let the app running
		  Return True
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub InitializeSentry()
		  Var DSN As String = "https://1b608ac1b69876e8978450d90b591290@o4509742417051648.ingest.de.sentry.io/4509742423605328"
		  
		  Self.Sentry = SentryController.GetInstance(DSN)
		  Self.Sentry.SendOfflineExceptions //Send exceptions that were triggered when offline
		  
		  
		  //If necessary, Sentry has a few options
		  Self.Sentry.Options.app_name = "es.rcruz.fridgeplanner" //Your app's name
		  
		  'self.sentry.Options.get_battery_status = True //Only relevant on iOS
		  Self.Sentry.Options.include_StackFrame_address = False
		  Self.Sentry.Options.max_breadcrumbs = 100 //The maximum amount of breadcrumbs to keep
		  Self.Sentry.Options.persistant_breadcrumbs = 10 //The maximum amount of persistant breadcrumbs to keep. Defaults to 10
		  Self.Sentry.Options.sample_rate = 1.0 //Configures the sample rate for error events, in the range of 0.0 to 1.0. The default is 1.0 which means that 100% of error events are sent. If set to 0.1 only 10% of error events will be sent. Events are picked randomly.
		  Self.Sentry.Options.save_before_sending = False //Saves the exception to disk before sending to Sentry. Set to True before sending an UnhandledException or when the app is about to crash
		  Self.Sentry.Options.traces_sample_rate = 0.1 //Configures the sample rate for tracing events, in the range of 0.0 to 1.0. The default is 0.1 which means that 10% of traces events are sent. Traces are picked randomly.
		  
		  
		  //If your app handles user authentication add the info to sentry
		  
		  // Var user As New Xojo_Sentry.SentryUser
		  // user.email = "name@example.com"
		  // user.language = "en" //The language the user is running the app in
		  // user.locale = locale.Current
		  // 'user.ip = "1.1.1.1" //Uncomment this if necessary. Default is "{{auto}}"
		  // user.user_id = "1234" //The user's unique ID
		  // 
		  // Self.sentry.user = user
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		MealsManager As MealPlanManager
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Sentry As SentryController
	#tag EndProperty


	#tag Constant, Name = kDinnerMeals, Type = Text, Dynamic = False, Default = \"Grilled Salmon with Asparagus\nBeef Stroganoff\nChicken Parmesan\nLasagna\nGrilled Ribeye Steak\nShrimp Scampi\nRoast Chicken with Vegetables\nSpaghetti Carbonara\nLamb Chops with Mint Sauce\nFish and Chips\nChicken Marsala\nBeef Wellington\nLobster Thermidor\nPork Tenderloin with Apple Stuffing\nChicken Tikka Masala\nSeafood Paella\nPrime Rib with Yorkshire Pudding\nDuck Confit\nOsso Buco\nGrilled Swordfish\nChicken Cacciatore\nBeef Bourguignon\nStuffed Bell Peppers\nRack of Lamb\nCioppino\nChicken Cordon Bleu\nFilet Mignon\nPaella Valenciana\nMoroccan Tagine\nGrilled Halibut\nChicken Piccata\nBraised Short Ribs\nStuffed Pork Chops\nSeafood Risotto\nCoq au Vin\nNew York Strip Steak\nChilean Sea Bass\nChicken Enchiladas\nBeef Tenderloin\nPan-Seared Scallops\nChicken Fajitas\nVeal Scallopini\nGrilled Portobello Mushrooms\nSalmon Wellington\nChicken Teriyaki\nBraised Lamb Shanks\nStuffed Salmon\nBeef Medallions\nLobster Ravioli\nGrilled Chicken Breast\nPork Chops with Sage\nSeafood Linguine\nChicken Satay\nBeef Brisket\nPan-Fried Trout\nChicken Roulade\nGrilled Lamb Kebabs\nStuffed Eggplant\nSalmon Teriyaki\nBeef Fajitas\nLobster Bisque with Crab Cakes\nChicken Shawarma\nPork Belly with Asian Glaze\nSeafood Bouillabaisse\nGrilled Tuna Steaks\nChicken Pad Thai\nBeef Tacos\nPan-Seared Duck Breast\nStuffed Zucchini\nGrilled Mahi Mahi\nChicken Biryani\nLamb Curry\nSeafood Alfredo\nBeef Kabobs\nHoney Glazed Ham\nChicken Stir Fry\nGrilled Salmon Cedar Plank\nPork Schnitzel\nSeafood Gumbo\nBeef Pot Roast\nChicken Marsala\nGrilled Red Snapper\nLamb Gyros\nSeafood Chowder\nBeef Chili\nChicken Tikka\nGrilled Octopus\nPork Carnitas\nSeafood Pasta\nBeef Stir Fry\nChicken Shawarma Plate\nGrilled Branzino\nLamb Souvlaki\nSeafood Cioppino\nBeef Bulgogi\nChicken Pad See Ew\nGrilled Grouper\nPork Adobo\nSeafood Jambalaya\nBeef Rendang\nChicken Cacciatore\nGrilled Snapper\nLamb Tagine\nSeafood Boil\nBeef Teriyaki\nChicken Vindaloo\nPan-Seared Cod\nPork Sisig\nSeafood Curry", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLunchMeals, Type = Text, Dynamic = False, Default = \"Caesar Salad with Grilled Chicken\nTurkey and Avocado Wrap\nCaprese Sandwich\nGreek Salad with Feta\nChicken Quesadilla\nTuna Salad Sandwich\nButternut Squash Soup\nMediterranean Bowl\nBLT Sandwich\nQuinoa Power Bowl\nChicken Noodle Soup\nVeggie Burger with Sweet Potato Fries\nAsian Chicken Salad\nGrilled Cheese and Tomato Soup\nFish Tacos\nSpinach and Goat Cheese Salad\nClub Sandwich\nMinestrone Soup\nChicken Caesar Wrap\nPoke Bowl\nTurkey Meatball Sub\nLentil Soup\nCobb Salad\nPanini with Prosciutto and Mozzarella\nVietnamese Spring Rolls\nChicken Teriyaki Bowl\nFalafel Wrap\nGazpacho\nNicoise Salad\nItalian Sub\nRamen Bowl\nWaldorf Salad\nCuban Sandwich\nThai Curry Soup\nGarden Salad with Grilled Salmon\nChicken Pita Pocket\nMushroom Barley Soup\nAntipasto Salad\nBanh Mi Sandwich\nMiso Soup with Tofu\nSouthwest Chicken Salad\nPhilly Cheesesteak\nSplit Pea Soup\nKale and Quinoa Salad\nMonte Cristo Sandwich\nTom Yum Soup\nChicken Shawarma Bowl\nRueben Sandwich\nBroccoli Cheddar Soup\nArugula and Pear Salad\nTurkey Club Wrap", Scope = Private
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
		#tag ViewProperty
			Name="_LaunchOptionsHandled"
			Visible=false
			Group="Behavior"
			InitialValue="False"
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
			Name="NonReleaseVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MajorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IconBadgeNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BugVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StageCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
