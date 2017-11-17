//
//  BWSearchResultViewController.swift
//  BestWay
//
//  Created by solar on 16/11/16.
//  Copyright © 2016年 PigVillageStudio. All rights reserved.
//

import UIKit
// 搜索结果页面控制器
class BWSearchResultViewController: UIViewController {
    // MARK: - 搜索框
    var searchBar = UISearchBar()
    
    // MARK: - 页面传參字符串
    var itemString = ""
    
    // MARK: - 地图view
    var mapView = MAMapView()
    
    // MARK: - POI搜索对象
    var search:AMapSearchAPI?
    
    // MARK: - 搜索结果数组
    var searchResult:[AMapPOI] = []
    
    // MARK: - 搜索结果戳点
    var searchResultPoints:[MAPointAnnotation] = []
    
    // MARK: - 导航划线
    var commonPolyline: MAPolyline!
    
    // MARK: - 超出搜索范围的提示弹框
    var notFoundAlertView = UIAlertController()
    
    // MARK: - 路径搜索结果数组
    var route = AMapRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化界面
        initView()
        
        self.searchBarSearchButtonClicked()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - 初始化页面
    func initView(){
        // MARK: - 搜索框相关属性
        searchBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width - 50), height: 20)
        searchBar.text = itemString
        searchBar.delegate = self
        let rightNavBarBtn = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarBtn
        notFoundAlertView = UIAlertController.alertControllerWithTitle("找不到该地点", msg: "超出搜索范围了，请更换搜索关键字!")
        
        // MARK: - 地图显示的属性
        mapView = MAMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.zoomLevel = 13
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.none
        mapView.pausesLocationUpdatesAutomatically = false
        mapView.allowsBackgroundLocationUpdates = true
        mapView.distanceFilter = 10.0
        mapView.setCenter(CLLocationCoordinate2D.init(latitude: 22.347146, longitude: 113.533344), animated: true)
        
        self.view.addSubview(mapView)
    }

}

// MARK: - AMapSearchDelegate扩展方法
extension BWSearchResultViewController:AMapSearchDelegate {
    
    // MARK: - POI搜索的回调方法
    func onPOISearchDone(_ request:AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.pois.count == 0{
            print("pois===0!!")
            self.present(notFoundAlertView, animated: true, completion: nil)
            return
        }
        
        // 将搜索结果存进数组searchResult
        self.searchResult = response.pois as! [AMapPOI]
        
        // 遍历搜索结果数组
        for i in 0..<searchResult.count{
            let annotation = MAPointAnnotation()
            // 将结果坐标赋值给annotaion
            annotation.coordinate = CLLocationCoordinate2D.init(latitude: Double(searchResult[i].location.latitude), longitude: Double(searchResult[i].location.longitude))
            annotation.title = searchResult[i].name!
            
            // 将annotaion追加到搜索结果戳点数组
            searchResultPoints.append(annotation)
            
        }
        mapView.addAnnotations(searchResultPoints)
    }
    
    // MARK: - 路径规划信息搜索的回调方法
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if request.isKind(of: AMapWalkingRouteSearchRequest.self){
            if response.route == nil{
                return
            }
            // 默认选取路径规划信息中的第一条路
            let path = response.route.paths[0] as! AMapPath
            
            // 第一条路的经纬度数组
            var latitudes = [Double]()
            var longitudes = [Double]()
            
            // 第一条路的每一步
            var steps = path.steps
            
            // 划线节点数组
            var commonPolylineCoordinates = [CLLocationCoordinate2D]()
            
            // 构造折线对象
            commonPolyline = MAPolyline(coordinates: &commonPolylineCoordinates, count: UInt(commonPolylineCoordinates.count))
            mapView.add(commonPolyline)
            
            // 处理每个step的经纬度
            let count = (steps?.count)! as Int
            var totalDistance = 0
            for i in 0 ..< count{
                let step = steps?[i] as! AMapStep
                let locations = step.polyline.components(separatedBy: ";")
                totalDistance += step.distance
                for location in locations{
                    let location = location.components(separatedBy: ",")
                    let longitude = Double(location[0])
                    let latitude = Double(location[1])
                    longitudes.append(longitude!)
                    latitudes.append(latitude!)
                }
            }
            // 画线
            drawLine(latitudes, longitudes: longitudes)
        }
        
    }
    // MARK: - 画线方法
    func drawLine(_ latitudes:[Double], longitudes:[Double]) {
        // 构造折线数据对象
        var commonPolylineCoordinates = [CLLocationCoordinate2D]()
        for i in 0 ..< latitudes.count {
            let locationCoordinate = CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i])
            commonPolylineCoordinates.append(locationCoordinate)
        }
        
        // 构造折线对象
        commonPolyline = MAPolyline(coordinates: &commonPolylineCoordinates, count: UInt(latitudes.count))
        mapView.add(commonPolyline)
    }
    
}

// MARK: - MAMapViewDelegate扩展方法
extension BWSearchResultViewController:MAMapViewDelegate{
    
    // MARK: - 地图画线的代理方法重写
    func mapView(_ mapView: MAMapView!, viewFor overlay: MAOverlay!) -> MAOverlayView! {
        if overlay.isKind(of: MAPolyline.self) {
            let polylineView : MAPolylineView = MAPolylineView(polyline: overlay as! MAPolyline)
            polylineView.lineWidth = 4.0
            polylineView.strokeColor = UIColor(colorLiteralRed: 48/255, green: 163/255, blue: 240/255, alpha: 0.8)
            return polylineView
        }
        return nil
    }
    
    // MARK: - 地图标注的代理方法重写
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            
            let annotationIdentifier = "lcoationIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            let routePlanningBtn = UIButton(type: .system)
            routePlanningBtn.frame = CGRect(x: 10, y: 150, width: 50, height: 30)
            routePlanningBtn.setTitle("去这里", for: UIControlState())
            poiAnnotationView?.rightCalloutAccessoryView = routePlanningBtn
            
            return poiAnnotationView;
        }
        
        return nil
    }
    
    // MARK: - 处理气泡弹窗点击事件的代理方法重写
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        self.mapView.remove(commonPolyline)
        if control.isKind(of: UIControl.self){
            // 初始化检索对象
            self.search = AMapSearchAPI()
            self.search?.delegate = self
            
            // 用户位置
            let userLocation = mapView.userLocation
            
            // 目标位置
            let destinationLocation = MAPointAnnotation()
            
            // 获取目标位置
            destinationLocation.coordinate = view.annotation.coordinate
            
            // 构造AMapWalkingRouteSearchRequest对象
            let request = AMapWalkingRouteSearchRequest()
            request.origin = AMapGeoPoint.location(withLatitude: CGFloat(userLocation!.coordinate.latitude), longitude: CGFloat(userLocation!.coordinate.longitude))
            request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationLocation.coordinate.latitude), longitude: CGFloat(destinationLocation.coordinate.longitude))
            
            // 是否有备选路径，默认0
            request.multipath = 0
            
            // 发起路径搜索，导航
            search?.aMapWalkingRouteSearch(request)
            
        }
    }
}

// MARK: - BWSearchResultViewController的UISearchBarDelegate扩展方法
extension BWSearchResultViewController:UISearchBarDelegate {
    
    // MARK: - 搜索框搜索方法
    func searchBarSearchButtonClicked() {
        // 初始化搜索对象
        self.search = AMapSearchAPI()
        self.search!.delegate = self
        
        // POI搜索关键字
        let keywords = searchBar.text
        
        // 构建一个搜索request对象
        let request=AMapPOIAroundSearchRequest()
        let coordinate = CLLocationCoordinate2D.init(latitude: 22.347146, longitude: 113.533344)
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.keywords = keywords
        request.types = "生活服务|公共设施|科教文化服务|地名地址信息"
        request.sortrule = 0
        request.requireExtension = true
        search?.aMapPOIAroundSearch(request)
    }
    
    // MARK: - 搜索框重新搜索方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 去除上一次搜索结果
        self.mapView.removeAnnotations(mapView.annotations)
        searchResultPoints = []
        
        // 初始化搜索对象
        self.search = AMapSearchAPI()
        self.search!.delegate = self
        
        // POI搜索关键字
        let keywords = searchBar.text
        
        // 构建一个搜索request对象
        let request=AMapPOIAroundSearchRequest()
        let coordinate = CLLocationCoordinate2D.init(latitude: 22.347146, longitude: 113.533344)
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.keywords = keywords
        request.types = "生活服务|公共设施|科教文化服务|地名地址信息|高等院校"
        request.sortrule = 0
        request.requireExtension = true
        search?.aMapPOIAroundSearch(request)
    }
}
