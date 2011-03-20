package com.era7.bioinfo.go.comm
{
	public class UrlManager
	{
		
		public static const BASE_URL:String = "http://ec2-46-51-138-32.eu-west-1.compute.amazonaws.com:8080/GoAmazonServer/";
		
		public static const BASE_URL_BIO4J:String = "http://ec2-46-137-32-134.eu-west-1.compute.amazonaws.com:8080/Bio4jTestServer/";
		//public static const BASE_URL_BIO4J:String = "http://localhost:8080/Bio4jTestServer/";

		//public static const BASE_URL:String = "http://localhost:8080/Bio4jTestServer/";

		
		public static const GO_SLIM_URL:String = BASE_URL + "GoSlim";
		public static const GO_SLIM_URL_BIO4J:String = BASE_URL_BIO4J + "GoSlim";
		//public static const DOWNLOAD_GO_SLIM_URL:String = BASE_URL + "DownloadGoSlim";
		
		public static const GO_ANNOTATION_URL:String = BASE_URL + "GoAnnotation";
		public static const GO_ANNOTATION_URL_BIO4J:String = BASE_URL_BIO4J + "GoAnnotation";
		//public static const DOWNLOAD_GO_ANNOTATION_URL:String = BASE_URL + "DownloadGoAnnotation";
	}
}