#tag Class
Protected Class CKError
	#tag Method, Flags = &h0
		Sub Constructor(code As Integer, message As String)
		  Self.Code = code
		  Self.Message = message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromJSON(json As String) As CloudKit.CKError
		  // Parses a CloudKit REST API error response body
		  Var err As New CloudKit.CKError(0, "Unknown error")
		  Try
		    Var item As New JSONItem(json)
		    If item.HasKey("serverErrorCode") Then
		      err.ServerErrorCode = item.Value("serverErrorCode")
		    End If
		    If item.HasKey("reason") Then
		      err.Message = item.Value("reason")
		    End If
		    // Map known server error codes to numeric codes
		    Select Case err.ServerErrorCode
		    Case "NOT_AUTHENTICATED"
		      err.Code = 9
		    Case "NETWORK_FAILURE"
		      err.Code = 4
		    Case "SERVER_REJECTED_REQUEST"
		      err.Code = 15
		    Case "QUOTA_EXCEEDED"
		      err.Code = 25
		    Case "ZONE_NOT_FOUND"
		      err.Code = 26
		    Case "RECORD_DOES_NOT_EXIST"  // not really an error, handle at call site
		      err.Code = 11
		    Else
		      err.Code = -1
		    End Select
		  Catch
		    // Return generic error on parse failure
		  End Try
		  Return err
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Code As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Message As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ServerErrorCode As String
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
