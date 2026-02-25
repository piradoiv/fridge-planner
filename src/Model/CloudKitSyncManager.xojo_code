#tag Class
Protected Class CloudKitSyncManager
	#tag Method, Flags = &h0
		Sub Constructor(db As DatabaseManager, webAuthToken As String)
		  mDB = db
		  mCloudKit = New CloudKit.Manager
		  mCloudKit.WebAuthToken = webAuthToken
		  AddHandler mCloudKit.SaveCompleted, AddressOf HandleSaveCompleted
		  AddHandler mCloudKit.CloudKitError, AddressOf HandleCloudKitError
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleCloudKitError(sender As CloudKit.Manager, error As CloudKit.CKError)
		  IsSyncing = False
		  mSyncQueue.RemoveAll
		  RaiseEvent SyncFailed(error)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleSaveCompleted(sender As CloudKit.Manager, record As CloudKit.Record, error As CloudKit.CKError)
		  If error <> Nil Then
		    IsSyncing = False
		    RaiseEvent SyncFailed(error)
		    Return
		  End If
		  
		  // Persist the CloudKit record ID so future saves are updates, not creates
		  Var planUUID As String = record.Fields.Lookup("uuid", "").StringValue
		  If planUUID <> "" Then
		    mDB.SaveSyncMetadata(planUUID, record.RecordID)
		  End If
		  
		  // Continue with the next item in the queue
		  PushNext
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PushNext()
		  If mSyncQueue.Count = 0 Then
		    IsSyncing = False
		    RaiseEvent SyncCompleted
		    Return
		  End If
		  
		  Var plan As MealPlan = mSyncQueue(0)
		  mSyncQueue.RemoveAt(0)
		  
		  // Build a CloudKit record representing this meal plan
		  Var meta As Dictionary = mDB.GetSyncMetadata(plan.UUID)
		  Var recordID As String = meta.Lookup("cloudkit_record_id", "").StringValue
		  
		  Var record As CloudKit.Record
		  If recordID = "" Then
		    record = New CloudKit.Record("MealPlan", plan.UUID)
		  Else
		    record = New CloudKit.Record("MealPlan", recordID)
		  End If
		  
		  record.Fields.Value("name") = plan.Name
		  record.Fields.Value("uuid") = plan.UUID
		  record.Fields.Value("isActive") = If(plan.IsActive, 1, 0)
		  
		  mCloudKit.SaveRecord(record)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SyncAll()
		  If IsSyncing Or Not mCloudKit.IsAvailable Then Return
		  If mCloudKit.WebAuthToken = "" Then Return
		  
		  mSyncQueue = mDB.GetUnsyncedMealPlans
		  If mSyncQueue.Count = 0 Then
		    RaiseEvent SyncCompleted
		    Return
		  End If
		  
		  IsSyncing = True
		  PushNext
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event SyncCompleted()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SyncFailed(error As CloudKit.CKError)
	#tag EndHook


	#tag Property, Flags = &h0
		IsSyncing As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCloudKit As CloudKit.Manager
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDB As DatabaseManager
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSyncQueue() As MealPlan
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
