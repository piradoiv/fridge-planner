#tag Class
Protected Class Manager
	#tag Method, Flags = &h21
		Private Function BuildDeleteBody(recordType As String, recordID As String) As String
		  // POST /records/modify with operationType "delete"
		  Var rec As New JSONItem
		  rec.Value("recordName") = recordID
		  rec.Value("recordType") = recordType
		  
		  Var op As New JSONItem
		  op.Value("operationType") = "delete"
		  op.Value("record") = rec
		  
		  Var ops As New JSONItem
		  ops.Append(op)
		  
		  Var body As New JSONItem
		  body.Value("operations") = ops
		  Return body.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildFetchBody(recordType As String, recordID As String) As String
		  // POST /records/lookup — fetches a record by recordName
		  Var rec As New JSONItem
		  rec.Value("recordName") = recordID
		  
		  Var records As New JSONItem
		  records.Append(rec)
		  
		  Var body As New JSONItem
		  body.Value("records") = records
		  Return body.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildSaveBody(record As CloudKit.Record) As String
		  // POST /records/modify — creates or updates a record
		  Var op As New JSONItem
		  op.Value("operationType") = If(record.RecordID = "", "create", "update")
		  op.Value("record") = New JSONItem(record.ToJSON)
		  
		  Var ops As New JSONItem
		  ops.Append(op)
		  
		  Var body As New JSONItem
		  body.Value("operations") = ops
		  Return body.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mConnection = New URLConnection
		  AddHandler mConnection.ContentReceived, WeakAddressOf HandleContentReceived
		  AddHandler mConnection.Error, WeakAddressOf HandleConnectionError
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(recordType As String, recordID As String)
		  mPendingOperation = kOperationDelete
		  mPendingRecordID = recordID
		  MakeRequest("POST", "/records/modify", BuildDeleteBody(recordType, recordID))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FetchRecord(recordType As String, recordID As String)
		  mPendingOperation = kOperationFetch
		  mPendingRecordID = recordID
		  MakeRequest("POST", "/records/lookup", BuildFetchBody(recordType, recordID))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FetchWebAuthToken(apiKey As String)
		  // Fetches a per-user web auth token using a CloudKit Dashboard server-to-server API key.
		  // Generate the key at: https://icloud.developer.apple.com → your container → API Access → Server-to-Server Keys
		  mPendingOperation = kOperationToken
		  MakeRequest("GET", "/users/caller", "")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleConnectionError(sender As URLConnection, e As RuntimeException)
		  Var err As New CloudKit.CKError(-1, e.Message)
		  RaiseEvent CloudKitError(err)
		  mPendingOperation = ""
		  mPendingRecord = Nil
		  mPendingRecordID = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleContentReceived(sender As URLConnection, url As String, httpStatus As Integer, content As String)
		  If httpStatus >= 200 And httpStatus < 300 Then
		    Select Case mPendingOperation
		    Case kOperationSave
		      Var saved As CloudKit.Record = mPendingRecord
		      Try
		        Var root As New JSONItem(content)
		        If root.HasKey("records") Then
		          Var records As JSONItem = root.Value("records")
		          If records.Count > 0 Then
		            saved = CloudKit.Record.FromJSON(records.Child(0).ToString)
		          End If
		        End If
		      Catch
		      End Try
		      RaiseEvent SaveCompleted(saved, Nil)
		      
		    Case kOperationFetch
		      Var records() As CloudKit.Record = ParseRecords(content)
		      RaiseEvent FetchCompleted(records, Nil)
		      
		    Case kOperationDelete
		      RaiseEvent DeleteCompleted(mPendingRecordID, Nil)
		      
		    Case kOperationToken
		      // Response contains a webAuthToken field
		      Try
		        Var root As New JSONItem(content)
		        Var token As String = root.Value("webAuthToken")
		        Self.WebAuthToken = token
		        RaiseEvent WebAuthTokenFetched(token)
		      Catch
		        Var err As New CloudKit.CKError(-1, "Failed to parse web auth token response")
		        RaiseEvent CloudKitError(err)
		      End Try
		    End Select
		  Else
		    Var err As CloudKit.CKError = CloudKit.CKError.FromJSON(content)
		    Select Case mPendingOperation
		    Case kOperationSave
		      RaiseEvent SaveCompleted(Nil, err)
		    Case kOperationFetch
		      Var empty() As CloudKit.Record
		      RaiseEvent FetchCompleted(empty, err)
		    Case kOperationDelete
		      RaiseEvent DeleteCompleted(mPendingRecordID, err)
		    Case kOperationToken
		      RaiseEvent CloudKitError(err)
		    End Select
		  End If
		  
		  mPendingOperation = ""
		  mPendingRecord = Nil
		  mPendingRecordID = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAvailable() As Boolean
		  #If TargetIOS
		    Declare Function objc_getClass Lib "libobjc.A.dylib" (name As CString) As Ptr
		    Declare Function defaultManager Lib "Foundation" Selector "defaultManager" (clsRef As Ptr) As Ptr
		    Declare Function ubiquityIdentityToken Lib "Foundation" Selector "ubiquityIdentityToken" (obj As Ptr) As Ptr
		    Var fmClass As Ptr = objc_getClass("NSFileManager")
		    Var fm As Ptr = defaultManager(fmClass)
		    Var token As Ptr = ubiquityIdentityToken(fm)
		    Return token <> Nil
		  #Else
		    Return False
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MakeRequest(httpMethod As String, path As String, body As String)
		  // CloudKit private database REST endpoint
		  // Requires WebAuthToken to be set before calling
		  Var url As String = "https://api.apple-cloudkit.com/database/1/" + _
		  "iCloud.es.rcruz.fridgeplanner/" + kEnvironment + "/private" + path
		  
		  mConnection.RequestHeader("Content-Type") = "application/json"
		  If WebAuthToken <> "" Then
		    mConnection.RequestHeader("X-Apple-CloudKit-Request-WebAuthToken") = WebAuthToken
		  End If
		  mConnection.SetRequestContent(body, "application/json")
		  mConnection.Send(httpMethod, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseRecords(json As String) As CloudKit.Record()
		  Var result() As CloudKit.Record
		  Try
		    Var root As New JSONItem(json)
		    If root.HasKey("records") Then
		      Var records As JSONItem = root.Value("records")
		      For i As Integer = 0 To records.Count - 1
		        result.Add(CloudKit.Record.FromJSON(records.Child(i).ToString))
		      Next
		    End If
		  Catch
		    // Return empty array on parse error
		  End Try
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveRecord(record As CloudKit.Record)
		  mPendingOperation = kOperationSave
		  mPendingRecord = record
		  MakeRequest("POST", "/records/modify", BuildSaveBody(record))
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CloudKitError(error As CloudKit.CKError)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DeleteCompleted(recordID As String, error As CloudKit.CKError)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FetchCompleted(records() As CloudKit.Record, error As CloudKit.CKError)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SaveCompleted(record As CloudKit.Record, error As CloudKit.CKError)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event WebAuthTokenFetched(token As String)
	#tag EndHook


	#tag Property, Flags = &h21
		Private mConnection As URLConnection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPendingOperation As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPendingRecord As CloudKit.Record
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPendingRecordID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WebAuthToken As String
	#tag EndProperty


	#tag Constant, Name = kEnvironment, Type = String, Dynamic = False, Default = \"development", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kOperationDelete, Type = String, Dynamic = False, Default = \"delete", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kOperationFetch, Type = String, Dynamic = False, Default = \"fetch", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kOperationSave, Type = String, Dynamic = False, Default = \"save", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kOperationToken, Type = String, Dynamic = False, Default = \"token", Scope = Public
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
			Name="WebAuthToken"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
