#tag Class
Protected Class MealPlan
	#tag Method, Flags = &h0
		Sub Constructor()
		  UUID = GenerateUUID()
		  CreatedAt = DateTime.Now
		  ModifiedAt = DateTime.Now
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(name As String)
		  Self.Name = name
		  UUID = GenerateUUID()
		  CreatedAt = DateTime.Now
		  ModifiedAt = DateTime.Now
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GenerateUUID() As String
		  Var parts(15) As Integer
		  For i As Integer = 0 To 15
		    parts(i) = System.Random.InRange(0, 255)
		  Next
		  parts(6) = (parts(6) And &h0F) Or &h40
		  parts(8) = (parts(8) And &h3F) Or &h80

		  Var hex() As String
		  For i As Integer = 0 To 15
		    Var h As String = parts(i).ToHex
		    If h.Length = 1 Then h = "0" + h
		    hex.Add(h)
		  Next

		  Return hex(0) + hex(1) + hex(2) + hex(3) + "-" + _
		    hex(4) + hex(5) + "-" + _
		    hex(6) + hex(7) + "-" + _
		    hex(8) + hex(9) + "-" + _
		    hex(10) + hex(11) + hex(12) + hex(13) + hex(14) + hex(15)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		CloudKitRecordID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CreatedAt As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		ID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IsActive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ModifiedAt As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		UUID As String
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
			Name="ID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
