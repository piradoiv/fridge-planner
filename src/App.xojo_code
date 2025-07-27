#tag Class
Protected Class App
Inherits MobileApplication
	#tag CompatibilityFlags = TargetIOS
	#tag Event
		Sub Opening()
		  MealsManager = New MealPlanManager
		  
		  #If DebugBuild
		    For i As Integer = 0 To 364
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


	#tag Property, Flags = &h0
		MealsManager As MealPlanManager
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
