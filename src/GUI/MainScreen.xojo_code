#tag MobileScreen
Begin MobileScreen MainScreen Implements iOSMobileTableDataSourceReordering
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
   Begin MobileToolbarButton NextMonthButton
      Caption         =   "Next"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   290
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   20
      Width           =   22.0
   End
   Begin MobileToolbarButton PreviousMonthButton
      Caption         =   "Previous"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   8
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   19
      Width           =   22.0
   End
   Begin MobileSharingPanel Share
      Left            =   0
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   2
      Top             =   0
   End
   Begin CalendarContainer Calendar
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   Calendar, 4, DayPlanTable, 3, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   Calendar, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   Calendar, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   Calendar, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   247
      Left            =   0
      LockedInPosition=   False
      Scope           =   2
      TintColor       =   &c000000
      Top             =   65
      Visible         =   True
      Width           =   320
   End
   Begin MobileToolbarButton TodayButton
      Caption         =   "Today"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   8
      LockedInPosition=   False
      Scope           =   2
      Top             =   534
      Type            =   1001
      Width           =   46.0
   End
   Begin MobileToolbarButton GeneratePDFButton
      Caption         =   "Generate PDF"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   63
      LockedInPosition=   False
      Scope           =   2
      Top             =   534
      Type            =   1001
      Width           =   97.0
   End
   Begin Thread GeneratePDFThread
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Priority        =   5
      Scope           =   2
      StackSize       =   0
      Type            =   0
   End
   Begin DayPlanTableContainer DayPlanTable
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   DayPlanTable, 4, BottomLayoutGuide, 3, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 8, <Parent>, 8, False, +0.45, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DayPlanTable, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   255
      Left            =   0
      LockedInPosition=   False
      Scope           =   2
      TintColor       =   &c000000
      Top             =   312
      Visible         =   True
      Width           =   320
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  Var now As DateTime = DateTime.Now
		  CurrentDate = now
		  CurrentDate = CurrentDate.SubtractInterval(0, 0, CurrentDate.Day - 1)
		  
		  Calendar.SelectedDate = now
		  
		  LoadPlans
		  
		  PreviousMonthButton.Tag = "back"
		  NextMonthButton.Tag = "forward"
		  TodayButton.Tag = "today"
		  GeneratePDFButton.Tag = "pdf"
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button.Tag
		  Case "forward"
		    CurrentDate = CurrentDate.AddInterval(0, 1)
		    CurrentDate = CurrentDate.SubtractInterval(0, 0, CurrentDate.Day - 1)
		    Calendar.SelectedDate = CurrentDate
		    RegeneratePDF
		  Case "back"
		    CurrentDate = CurrentDate.SubtractInterval(0, 0, 1)
		    CurrentDate = CurrentDate.SubtractInterval(0, 0, CurrentDate.Day - 1)
		    Calendar.SelectedDate = CurrentDate
		    RegeneratePDF
		  Case "pdf"
		    Var s As New DecorationScreen
		    s.Decoration = mDecoration
		    AddHandler s.GeneratePDFWithDecoration, WeakAddressOf GeneratePDFWithDecorationHandler
		    s.ShowModal(Self)
		  Case "today"
		    Var now As DateTime = DateTime.Now
		    CurrentDate = New DateTime(now.Year, now.Month, 1)
		    Calendar.SelectedDate = now
		    LoadPlans
		  End Select
		  
		  LoadPlans
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function AllowRowMove(table As iOSMobileTable, section As Integer, row As Integer) As Boolean
		  // Part of the iOSMobileTableDataSourceReordering interface.
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GeneratePDF() As FolderItem
		  Const outerPadding = 40
		  Const titleHeight = 30
		  Const headerHeight = 10
		  
		  Var pdf As New PDFDocument(PDFDocument.PageSizes.A4)
		  pdf.Landscape = True
		  Var g As Graphics = pdf.Graphics
		  
		  // Draw the border decoration
		  If mDecoration <> "" Then
		    Var chars() As String = mDecoration.Characters
		    Var pics() As Picture
		    Const emojiPicSize = 256
		    For i As Integer = 0 To chars.LastIndex
		      Var emojiPic As New Picture(emojiPicSize, emojiPicSize)
		      Var gg As Graphics = emojiPic.Graphics
		      
		      Var c As String = chars(System.Random.InRange(0, chars.LastIndex))
		      gg.Font = New Font("Helvetica", emojiPicSize)
		      Var textWidth As Double = gg.TextWidth(c)
		      Var textHeight As Double = gg.TextHeight(c, 1000)
		      gg.DrawText(c, 0, gg.Font.Ascent * .9)
		      
		      pics.Add(emojiPic)
		    Next
		    
		    For i As Integer = 1 To 256
		      Var pic As Picture = pics(System.Random.InRange(0, pics.LastIndex))
		      Var emojiSize As Integer = System.Random.InRange(25, 50)
		      Var randomX As Integer = System.Random.InRange(-25, g.Width)
		      Var randomY As Integer = System.Random.InRange(-25, g.Height)
		      
		      g.DrawPicture(pic, randomX, randomY, emojiSize, emojiSize, 0, 0, pic.Width, pic.Height)
		    Next
		  End If
		  
		  // Clear the zone where the title and week days will appear
		  g.DrawingColor = Color.White
		  g.FillRectangle(outerPadding, 0, g.Width - outerPadding * 2, g.Height - outerPadding)
		  
		  // Initial calculations
		  Var firstDay As DateTime = CurrentDate
		  Var lastDay As DateTime = CurrentDate.AddInterval(0, 1, 0).SubtractInterval(0, 0, 1)
		  Var firstWeek As Integer = firstDay.WeekOfYear
		  Var lastWeek As Integer = lastDay.WeekOfYear
		  
		  Var dayOfWeek As Integer = firstDay.DayOfWeek - 2
		  If dayOfWeek < 0 Then
		    dayOfWeek = dayOfWeek + 7
		  End If
		  
		  // I want to display the whole week, even if it's the previous or next month
		  firstDay = firstDay.SubtractInterval(0, 0, dayOfWeek)
		  dayOfWeek = 0
		  Var lastDayOfWeek As Integer = lastDay.DayOfWeek - 2
		  If lastDayOfWeek < 0 Then
		    lastDayOfWeek = lastDayOfWeek + 7
		  End If
		  lastDay = lastDay.AddInterval(0, 0, 6 - lastDayOfWeek)
		  
		  // Prepare cell dimensions
		  Var firstDayOfYear As Integer = firstDay.DayOfYear
		  Var lastDayOfYear As Integer = lastDay.DayOfYear
		  If lastDayOfYear < firstDayOfYear Then
		    lastDayOfYear = lastDayOfYear + 365
		  End If
		  Var weekCount As Integer = 1 + (lastDayOfYear - firstDayOfYear) / 7
		  Var currentWeek As Integer = 0
		  
		  Var cellWidth As Double = (pdf.PageWidth - outerPadding * 2) / 7
		  Var cellHeight As Double = (pdf.PageHeight - outerPadding * 2 - titleHeight - headerHeight) / weekCount
		  
		  // Draw title and header
		  g.Font = New Font("Helvetica Bold", 20)
		  g.DrawingColor = Color.Black
		  Var monthName As String = CurrentDate.ToString("MMMM YYYY").Titlecase
		  Var monthNameWidth As Double = g.TextWidth(monthName)
		  g.DrawText(monthName, g.Width / 2 - monthNameWidth / 2, titleHeight / 2 + g.Font.Ascent)
		  
		  g.Font = New Font("Helvetica Bold", 16)
		  Var dayNames() As String = Array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
		  For i As Integer = 0 To dayNames.LastIndex
		    Var day As String = dayNames(i)
		    Var dayNameWidth As Double = g.TextWidth(day)
		    Var x As Double = cellWidth * i + outerPadding + cellWidth / 2 - dayNameWidth / 2
		    Var y As Double = headerHeight / 2 + outerPadding + titleHeight - g.Font.Ascent / 2
		    g.DrawText(day, x, y)
		  Next
		  
		  // Draw the cells
		  Var currentDay As DateTime = New DateTime(firstDay)
		  While currentDay <= lastDay
		    Var x As Double = dayOfWeek * cellWidth + outerPadding
		    Var y As Double = currentWeek * cellHeight + outerPadding + titleHeight + headerHeight
		    
		    Var plan As DailyPlan = App.MealsManager.GetPlanForDate(currentDay)
		    
		    g.DrawingColor = plan.BackgroundColor
		    g.FillRectangle(x, y, cellWidth, cellHeight)
		    
		    g.PenSize = plan.BorderSize
		    g.DrawingColor = If(plan.BorderSize > 1, Color.Black, Color.LightGray)
		    g.DrawRectangle(x, y, cellWidth, cellHeight)
		    
		    g.DrawingColor = Color.DarkGray
		    g.Font = New Font("Helvetica", 12)
		    g.DrawText(currentDay.Day.ToString, x + 5, y + 5 + g.Font.Ascent)
		    
		    // Draw the daily plan
		    g.Font = New Font("Helvetica", 10)
		    g.DrawingColor = Color.Black
		    If plan = Nil Then
		      Continue
		    End If
		    
		    Var lunchMeals() As String
		    For Each lunch As Meal In plan.Lunch
		      lunchMeals.Add(lunch.Name)
		    Next
		    Var mealsText As String = String.FromArray(lunchMeals, ", ")
		    g.DrawText(mealsText, x + 5, y + 30, cellWidth - 10, False)
		    
		    Var dinnerMeals() As String
		    For Each dinner As Meal In plan.Dinner
		      dinnerMeals.Add(dinner.Name)
		    Next
		    Var dinnerText As String = String.FromArray(dinnerMeals, ", ")
		    Var dinnerHeight As Double = g.TextHeight(dinnerText, cellWidth - 10)
		    g.DrawText(dinnerText, x + 5, y + cellHeight - dinnerHeight, cellWidth - 10, False)
		    
		    // Increment day and week, if necessary
		    currentDay = currentDay.AddInterval(0, 0, 1)
		    dayOfWeek = dayOfWeek + 1
		    If dayOfWeek > 6 Then
		      dayOfWeek = 0
		      currentWeek = currentWeek + 1
		    End If
		  Wend
		  
		  // Save the file
		  Var documents As FolderItem = SpecialFolder.Documents.Child("es.rcruz.fridgeplanner")
		  If Not documents.Exists Then
		    documents.CreateFolder
		  End If
		  Var f As FolderItem = documents.Child("export.pdf")
		  If f.Exists Then
		    f.Remove
		  End If
		  
		  pdf.Save(f)
		  
		  Return f
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GeneratePDFWithDecorationHandler(sender As DecorationScreen, decoration As String)
		  If mPDFFile = Nil Or mDecoration <> decoration Then
		    mDecoration = decoration
		    If GeneratePDFThread.ThreadState = Thread.ThreadStates.Running Then
		      GeneratePDFThread.Stop
		    End If
		    mShouldShowPDF = True
		    GeneratePDFThread.Start
		  Else
		    mShouldShowPDF = False
		    ShowPDF
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadPlans()
		  Self.Title = CurrentDate.ToString("MMMM YYYY").Titlecase
		  App.MealsManager.LoadPlansForMonth(CurrentDate.Year, CurrentDate.Month)
		  
		  DayPlanTable.Plan = App.MealsManager.GetPlanForDate(Calendar.SelectedDate)
		  DayPlanTable.Reload
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RegeneratePDF()
		  If GeneratePDFThread.ThreadState = Thread.ThreadStates.Running Then
		    GeneratePDFThread.Stop
		  End If
		  
		  mPDFFile = Nil
		  mShouldShowPDF = False
		  GeneratePDFThread.Start
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Return App.MealsManager.MonthDayCount(App.MealsManager.Year, App.MealsManager.Month)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Part of the iOSMobileTableDataSource interface.
		  
		  Var result As MobileTableCellData
		  Var plan As DailyPlan
		  For i As Integer = 0 To App.MealsManager.Plans.LastIndex
		    If App.MealsManager.Plans(i).PlanDate.Day = row + 1 Then
		      plan = App.MealsManager.Plans(i)
		      Exit For i
		    End If
		  Next
		  
		  If plan = Nil Then
		    Var day As New DateTime(App.MealsManager.Year, App.MealsManager.Month, row + 1)
		    result = table.CreateCell("-", day.SQLDate, Nil, MobileTableCellData.AccessoryTypes.Disclosure)
		    plan = New DailyPlan
		    plan.PlanDate = day
		  Else
		    Var lunch() As String
		    For Each meal As Meal In plan.Lunch
		      lunch.Add(meal.Name)
		    Next
		    Var dinner() As String
		    For Each meal As Meal In plan.Dinner
		      dinner.Add(meal.Name)
		    Next
		    Var meals() As String
		    If lunch.Count > 0 Then
		      meals.Add("🍽️: " + String.FromArray(lunch, ", "))
		    End If
		    If dinner.Count > 0 Then
		      meals.Add("🥡: " + String.FromArray(dinner, ", "))
		    End If
		    
		    result = table.CreateCell(If(meals.Count > 0, String.FromArray(meals, " | "), "-"), plan.PlanDate.SQLDate + " " + plan.Notes, Nil, MobileTableCellData.AccessoryTypes.Disclosure)
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
		Private Sub ShowPDF()
		  Var s As New PDFScreen
		  s.PDF = mPDFFile
		  s.Show(Self)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CurrentDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDecoration As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPDFFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mShouldShowPDF As Boolean
	#tag EndProperty


#tag EndWindowCode

#tag Events Calendar
	#tag Event
		Sub DaySelected(date As DateTime)
		  CurrentDate = New DateTime(date.Year, date.Month, 1)
		  LoadPlans
		  RegeneratePDF
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events GeneratePDFThread
	#tag Event
		Sub Run()
		  Var f As FolderItem = GeneratePDF
		  
		  Me.AddUserInterfaceUpdate("pdf" : f)
		End Sub
	#tag EndEvent
	#tag Event
		Sub UserInterfaceUpdate(data() As Dictionary)
		  Var lastUpdate As Dictionary = data(data.LastIndex)
		  
		  mPDFFile = lastUpdate.Value("pdf")
		  
		  If mShouldShowPDF Then
		    Var s As New PDFScreen
		    s.PDF = mPDFFile
		    s.Show(Self)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DayPlanTable
	#tag Event
		Sub ReloadRequested()
		  LoadPlans
		  RegeneratePDF
		  Calendar.Reload
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
