#tag Class
Protected Class Record
	#tag Method, Flags = &h0
		Sub Constructor()
		  Fields = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(recordType As String, recordID As String)
		  Self.RecordType = recordType
		  Self.RecordID = recordID
		  Fields = New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromJSON(json As String) As CloudKit.Record
		  // Parses a single record object from the CloudKit REST API response
		  Var rec As New CloudKit.Record
		  Try
		    Var item As New JSONItem(json)
		    rec.RecordID = item.Value("recordName")
		    rec.RecordType = item.Value("recordType")
		    
		    If item.HasKey("modified") Then
		      Var modifiedEpochMs As Double = JSONItem(item.Value("modified")).Value("timestamp")
		      Var tz As New Timezone(0)
		      Var epoch As New DateTime(1970, 1, 1, 0, 0, 0, 0, tz)
		      rec.Modified = epoch.AddInterval(0, 0, 0, 0, 0, modifiedEpochMs / 1000)
		    End If
		    
		    If item.HasKey("fields") Then
		      Var fieldsItem As JSONItem = item.Value("fields")
		      For Each key As String In fieldsItem.Keys
		        Var fieldObj As JSONItem = fieldsItem.Value(key)
		        rec.Fields.Value(key) = fieldObj.Value("value")
		      Next
		    End If
		  Catch
		    // Return partially-populated record on parse error
		  End Try
		  Return rec
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSON() As String
		  // Builds the CloudKit REST API record payload for this record
		  Var fieldsObj As New JSONItem
		  For Each entry As DictionaryEntry In Fields
		    Var fieldValue As New JSONItem
		    Select Case entry.Value.Type
		    Case Variant.TypeString
		      fieldValue.Value("value") = entry.Value.StringValue
		      fieldValue.Value("type") = "STRING"
		    Case Variant.TypeInteger, Variant.TypeInt64
		      fieldValue.Value("value") = entry.Value.Int64Value
		      fieldValue.Value("type") = "INT64"
		    Case Variant.TypeDouble, Variant.TypeSingle
		      fieldValue.Value("value") = entry.Value.DoubleValue
		      fieldValue.Value("type") = "DOUBLE"
		    Case Variant.TypeBoolean
		      fieldValue.Value("value") = If(entry.Value.BooleanValue, 1, 0)
		      fieldValue.Value("type") = "INT64"
		    End Select
		    fieldsObj.Value(entry.Key.StringValue) = fieldValue
		  Next
		  
		  Var rec As New JSONItem
		  rec.Value("recordType") = RecordType
		  If RecordID <> "" Then
		    rec.Value("recordName") = RecordID
		  End If
		  rec.Value("fields") = fieldsObj
		  Return rec.ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Fields As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		RecordID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RecordType As String
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
			Name="RecordID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RecordType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
