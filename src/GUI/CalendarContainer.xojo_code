#tag MobileContainer
Begin MobileContainer CalendarContainer
   AccessibilityHint=   ""
   AccessibilityLabel=   ""
   Compatibility   =   ""
   Device = 7
   Height          =   300
   Left            =   0
   Orientation = 0
   Top             =   0
   Visible         =   True
   Width           =   320
   Begin MobileCanvas DaysCanvas
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowKeyEvents  =   False
      AutoLayout      =   DaysCanvas, 4, <Parent>, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   DaysCanvas, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   DaysCanvas, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   DaysCanvas, 3, HeaderCanvas, 4, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   270
      Left            =   20
      LockedInPosition=   False
      Scope           =   2
      TintColor       =   &c000000
      Top             =   30
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
   Begin MobileCanvas HeaderCanvas
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowKeyEvents  =   False
      AutoLayout      =   HeaderCanvas, 8, , 0, False, +1.00, 4, 1, 30, , True
      AutoLayout      =   HeaderCanvas, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   HeaderCanvas, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   HeaderCanvas, 3, <Parent>, 3, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   20
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   2
      TintColor       =   &c000000
      Top             =   0
      Visible         =   True
      Width           =   280
      _ClosingFired   =   False
   End
End
#tag EndMobileContainer

#tag WindowCode
	#tag Method, Flags = &h0
		Sub Reload()
		  DaysCanvas.Refresh
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event DaySelected(date As DateTime)
	#tag EndHook


	#tag Property, Flags = &h21
		Private mSelectedDate As DateTime
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mSelectedDate
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSelectedDate = value
			  Reload
			End Set
		#tag EndSetter
		SelectedDate As DateTime
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events DaysCanvas
	#tag Event
		Sub Paint(g As Graphics)
		  Const padding = 0
		  Const innerPadding = 7
		  
		  Var firstDay As New DateTime(SelectedDate.Year, SelectedDate.Month, 1)
		  
		  Var firstDayOfWeek As Integer = firstDay.DayOfWeek - 2
		  If firstDayOfWeek < 0 Then
		    firstDayOfWeek = firstDayOfWeek + 7
		  End If
		  
		  firstDay = firstDay.SubtractInterval(0, 0, firstDayOfWeek)
		  Var lastDay As DateTime = firstDay.AddInterval(0, 0, 41)
		  
		  Var rows As Integer = 6
		  
		  Var cellWidth As Double = (g.Width - padding * 2) / 7
		  Var cellHeight As Double = (g.Height - padding) / rows
		  
		  Var i As Integer = 0
		  Var j As Integer = 0
		  Var currentDay As New DateTime(firstDay)
		  While currentDay.SQLDate <= lastDay.SQLDate
		    Var x As Double = padding + cellWidth * i
		    Var y As Double = cellHeight * j
		    Var isSelectedDate As Boolean = currentDay.Year = SelectedDate.Year And currentDay.Month = SelectedDate.Month And currentDay.Day = SelectedDate.Day
		    
		    g.Font = If(isSelectedDate, Font.BoldSystemFont, Font.SystemFont)
		    g.DrawingColor = If(currentDay.Month = SelectedDate.Month, Color.Black, Color.LightGray)
		    If currentDay.SQLDate = DateTime.Now.SQLDate Then
		      g.Font = Font.BoldSystemFont
		      g.DrawingColor = Color.Red
		    End If
		    
		    Var dayString As String = currentDay.Day.ToString
		    Var dayStringWidth As Double = g.TextWidth(dayString)
		    
		    If isSelectedDate Then
		      g.DrawingColor = Color.Black
		      g.FillOval(x + cellWidth / 2 - g.Font.Ascent, y + innerPadding / 2, g.Font.Ascent * 2, g.Font.Ascent * 2)
		      g.DrawingColor = Color.White
		    End If
		    g.DrawText(dayString, x + cellWidth / 2 - dayStringWidth / 2, y + g.Font.Ascent + innerPadding)
		    
		    Var plan As DailyPlan = App.MealsManager.GetPlanForDate(currentDay)
		    If plan <> Nil Then
		      Var indicatorParts As Integer = 0
		      If plan.Lunch.Count > 0 Then
		        indicatorParts = indicatorParts + 1
		      End If
		      
		      If plan.Dinner.Count > 0 Then
		        indicatorParts = indicatorParts + 1
		      End If
		      
		      If plan.Notes <> "" Then
		        indicatorParts = indicatorParts + 1
		      End If
		      
		      Var planIndicatorWidth As Double = 30 / indicatorParts
		      Var planIndicatorHeight As Double = 6
		      
		      Var currentX As Double = x + cellWidth / 2 - (planIndicatorWidth * indicatorParts / 2)
		      If plan.Lunch.Count > 0 Then
		        g.DrawingColor = Color.Green
		        g.FillRoundRectangle(currentX, y + cellHeight - planIndicatorHeight - innerPadding + 3, planIndicatorWidth, planIndicatorHeight, 4, 4)
		        currentX = currentX + planIndicatorWidth
		      End If
		      If plan.Dinner.Count > 0 Then
		        g.DrawingColor = Color.Orange
		        g.FillRoundRectangle(currentX, y + cellHeight - planIndicatorHeight - innerPadding + 3, planIndicatorWidth, planIndicatorHeight, 4, 4)
		        currentX = currentX + planIndicatorWidth
		      End If
		      If plan.Notes <> "" Then
		        g.DrawingColor = Color.Blue
		        g.FillRoundRectangle(currentX, y + cellHeight - planIndicatorHeight - innerPadding + 3, planIndicatorWidth, planIndicatorHeight, 4, 4)
		        currentX = currentX + planIndicatorWidth
		      End If
		    End If
		    
		    // Prepare the next day
		    i = (i + 1) Mod 7
		    If i = 0 Then
		      j = j + 1
		    End If
		    currentDay = currentDay.AddInterval(0, 0, 1)
		  Wend
		End Sub
	#tag EndEvent
	#tag Event
		Sub PointerDown(position As Point, pointerInfo() As PointerEvent)
		  Var firstDay As New DateTime(SelectedDate.Year, SelectedDate.Month, 1)
		  
		  Var firstDayOfWeek As Integer = firstDay.DayOfWeek - 2
		  If firstDayOfWeek < 0 Then
		    firstDayOfWeek = firstDayOfWeek + 7
		  End If
		  
		  firstDay = firstDay.SubtractInterval(0, 0, firstDayOfWeek)
		  Var lastDay As DateTime = firstDay.AddInterval(0, 0, 41)
		  
		  Var cellWidth As Double = Me.Width / 7
		  Var cellHeight As Double = Me.Height / 6
		  
		  Var col As Integer = Floor(position.X / cellWidth)
		  Var row As Integer = Floor(position.Y / cellHeight)
		  
		  SelectedDate = firstDay.AddInterval(0, 0, col + row * 7)
		  
		  RaiseEvent DaySelected(SelectedDate)
		  
		  Me.Refresh
		End Sub
	#tag EndEvent
	#tag Event
		Sub PointerUp(position As Point, pointerInfo() As PointerEvent)
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events HeaderCanvas
	#tag Event
		Sub Paint(g As Graphics)
		  Var dayNames() As String = Array("MON", "TUE", "WED", "TUE", "FRI", "SAT", "SUN")
		  Var cellWidth As Double = g.Width / 7
		  g.Font = Font.BoldSystemFont(13)
		  
		  For i As Integer = 0 To 6
		    g.DrawingColor = If(i < 5, Color.Black, Color.LightGray)
		    Var dayWidth As Double = g.TextWidth(dayNames(i))
		    g.DrawText(dayNames(i), i * cellWidth + cellWidth / 2 - dayWidth / 2, g.Height - 5)
		  Next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="TintColor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
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
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AccessibilityHint"
		Visible=false
		Group="UI Control"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AccessibilityLabel"
		Visible=false
		Group="UI Control"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="UI Control"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="UI Control"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=false
		Group=""
		InitialValue="320"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=false
		Group=""
		InitialValue="480"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
