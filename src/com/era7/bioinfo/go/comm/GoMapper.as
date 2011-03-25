package com.era7.bioinfo.go.comm
{
	import com.era7.bioinfo.xml.go.SlimSet;
	import com.era7.communication.interfaces.ServerCallable;
	import com.era7.communication.model.BasicMapper;
	import com.era7.communication.xml.Parameters;
	import com.era7.communication.xml.Request;
	import com.era7.util.debug.Debugger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	
	public class GoMapper extends BasicMapper
	{
		private static var requestId:Number = 100000;
		
		private var reference:FileReference = null;
		private var urlLoader:URLLoader = null;
		
		private var lastRequest:Request = null;
		private var resultFile:File = null;
		
		private var fileToSaveResult:File = null;
		
		public function GoMapper()
		{
			super();
			reference = new FileReference();
			reference.addEventListener(Event.COMPLETE,onDownloadComplete);
			reference.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,onCompleteUrlLoader);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		/*
		*	GO SLIM
		*/
		public function goSlim(proteins:XML, 
							   slimSet:SlimSet,
							   countGos:Boolean,
							   file:File,
							   mysqlVersion:Boolean = true):void
		{
			
			fileToSaveResult = file;
			
			var temp:Request = new Request();
			temp.setID(""+requestId++);
			temp.setMethod(RequestList.GO_SLIM_REQUEST);
			
			var params:Parameters = new Parameters();
			params.addParametersContent(proteins);
			params.addParametersContent(slimSet.getContent());
			params.addParametersContent(<count_gos>{countGos}</count_gos>);
			temp.setParameters(params);
			
			var urlRequest:URLRequest = null;
			if(mysqlVersion){
				urlRequest = new URLRequest(UrlManager.GO_SLIM_URL);
			}else{
				urlRequest = new URLRequest(UrlManager.GO_SLIM_URL_BIO4J);
			}
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.idleTimeout = 18000000;
			var vars:URLVariables = new URLVariables();		
			
			Debugger.appendText(temp.toString(),Debugger.REQUEST_MODE);
			
			vars.request = temp.toString();
			urlRequest.data = vars; 
			
			urlLoader.load(urlRequest);
			
		}
		
		
		
		public function downloadGoSlimUsingJava(proteins:XML, 
												slimSet:SlimSet,
												countGos:Boolean,
												callable:ServerCallable):void
		{
			
			var temp:Request = new Request();
			temp.setID(""+requestId++);
			temp.setMethod(RequestList.DOWNLOAD_GO_SLIM_REQUEST);
			
			var params:Parameters = new Parameters();
			params.addParametersContent(<file_name>goSlim</file_name>);
			params.addParametersContent(<count_gos>{countGos}</count_gos>);
			params.addParametersContent(proteins);
			params.addParametersContent(slimSet.getContent());			
			temp.setParameters(params);
			
			lastRequest = temp;
			
			resultFile = new File();
			resultFile.addEventListener(Event.SELECT,onResultFileSelectGoSlim);
			resultFile.browseForSave("results.xml");
			
			/*var urlRequest:URLRequest = new URLRequest(UrlManager.DOWNLOAD_GO_SLIM_URL);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.idleTimeout = 18000000;
			var vars:URLVariables = new URLVariables();
			vars.request = temp.toString();
			urlRequest.data = vars; 
			
			
			
			reference.download(urlRequest);	*/
		}
		
		/*
		*	GO ANNOTATION
		*/
		public function goAnnotation(proteins:XML, file:File, mysqlVersion:Boolean = true):void
		{
			
			fileToSaveResult = file;
			
			var temp:Request = new Request();
			temp.setID(""+requestId++);
			temp.setMethod(RequestList.GO_ANNOTATION_REQUEST);
			
			var params:Parameters = new Parameters();
			params.addParametersContent(proteins);
			temp.setParameters(params);
			
			
			var urlRequest:URLRequest = null;
			if(mysqlVersion){
				urlRequest = new URLRequest(UrlManager.GO_ANNOTATION_URL);
			}else{
				urlRequest = new URLRequest(UrlManager.GO_ANNOTATION_URL_BIO4J);
			}
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.idleTimeout = 18000000;
			var vars:URLVariables = new URLVariables();
			
			//Debugger.appendText(temp.toString(),Debugger.REQUEST_MODE);
			
			vars.request = temp.toString();
			urlRequest.data = vars; 
			
			urlLoader.load(urlRequest);	 
			
		}
				
		
		private function onResultFileSelectGoSlim(event:Event):void{
			Alert.show(resultFile.toString());
		}
		
		private function onDownloadComplete(event:Event):void{
			Alert.show("File downloaded!");
		}
		private function onCompleteUrlLoader(event:Event):void{
			
			var response:XML = XML(String(urlLoader.data));		
			
			//Debugger.appendText(response.toXMLString(),Debugger.RESPONSE_MODE);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(fileToSaveResult,FileMode.WRITE);
			
			if(response.go_annotation[0] != null){
				fileStream.writeUTFBytes(XML(response.go_annotation[0]).toXMLString());
			}else{
				fileStream.writeUTFBytes(XML(response.go_slim[0]).toXMLString());
			}
			
			fileStream.close();
			Alert.show("File downloaded!");
		}
		private function onIOError(event:IOErrorEvent):void{
			Alert.show(event.toString());
		}
	}
}