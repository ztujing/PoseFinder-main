//
//  ScaledPoseHelper.swift
//  PoseFinder
//
//  Created by tujing on 2023/07/11.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class ScaledPoseHelper {
    var teacherPose = Pose()
    var scaledPose = Pose()
    var studentPose = Pose()
    var teacherCenterOfGravity:CGPoint? = CGPoint()
    var studentCenterOfGravity:CGPoint? = CGPoint()
    var ratio = TeacherStudentRatio.getInstance()
    
    init (teacherPose: Pose,studentPose: Pose) {
        self.teacherPose = teacherPose;
        self.studentPose = studentPose;
        //先生のグラビティを計算
        self.teacherCenterOfGravity = self.multiply(0.25, add(add(rawP("rSh"), rawP("lSh")),add(rawP("rHi"), rawP("lHi"))));
        //生徒のグラビティを計算
        self.studentCenterOfGravity = self.multiply(0.25, add(add(rawSP("rSh"), rawSP("lSh")),add(rawSP("rHi"), rawSP("lHi"))));
    }
    func rePos (position:CGPoint?) -> CGPoint {
        if let pos = self.add(position,self.studentCenterOfGravity) {
            return pos
        }
        return CGPoint(x: 0,y: 0)
    }
    
    func getScaledPose () -> Pose {
        
        guard let tRSh = rawP("rSh"),let sRSh = rawSP("rSh") else {
            return Pose()
        }
        // 比率
        var sLength = sqrt(sRSh.x*sRSh.x+sRSh.y*sRSh.y)
        var tLength = sqrt(tRSh.x*tRSh.x+tRSh.y*tRSh.y)
        if (tLength == 0 ){
            return Pose()
        }
        var tsRatio = sLength/tLength
        
        //rightShoulder
        var pos_rSh = self.multiply(ratio.originToRightShoulder, p("rSh"))
        // scaledPoseがStudentPoseになるように比率を掛け算する
        pos_rSh = self.multiply(tsRatio,pos_rSh)
        self.scaledPose.joints[.rightShoulder]?.position = rePos(position: pos_rSh)
        if (pos_rSh != nil) {
            self.scaledPose.joints[.rightShoulder]?.confidence = 1.0
            self.scaledPose.joints[.rightShoulder]?.isValid = true
        } else {
            self.scaledPose.joints[.rightShoulder]?.confidence = 0.0
            self.scaledPose.joints[.rightShoulder]?.isValid = false
        }
        
        //rightElbow
        var pos_rEl = self.add(pos_rSh,self.multiply(ratio.rightShoulderToRightElbow, self.sub(p("rEl"),p("rSh"))))
        pos_rEl = self.multiply(tsRatio,pos_rEl)
        self.scaledPose.joints[.rightElbow]?.position = rePos(position: pos_rEl)
        if(pos_rEl != nil) {
            self.scaledPose.joints[.rightElbow]?.confidence = 1.0
            self.scaledPose.joints[.rightElbow]?.isValid =  true
        }else {
            self.scaledPose.joints[.rightElbow]?.confidence = 0.0
            self.scaledPose.joints[.rightElbow]?.isValid =  false
        }
        //rightWrist
        var pos_rWr = self.add(pos_rEl,multiply(ratio.rightElbowToRightWrist, self.sub(p("rWr"),p("rEl"))))
        pos_rWr = self.multiply(tsRatio,pos_rWr)
        self.scaledPose.joints[.rightWrist]?.position = rePos(position: pos_rWr)
        if(pos_rWr != nil) {
            self.scaledPose.joints[.rightWrist]?.confidence = 1.0
            self.scaledPose.joints[.rightWrist]?.isValid =  true
        }else {
            self.scaledPose.joints[.rightWrist]?.confidence = 0.0
            self.scaledPose.joints[.rightWrist]?.isValid =  false
        }
        
        //rightHip
        var pos_rHi = self.multiply(ratio.originToRightHip, p("rHi"))
        pos_rHi = self.multiply(tsRatio,pos_rHi)
        self.scaledPose.joints[.rightHip]?.position = rePos(position: pos_rHi)
        if(pos_rHi != nil) {
            self.scaledPose.joints[.rightHip]?.confidence = 1.0;
            self.scaledPose.joints[.rightHip]?.isValid =  true;
        }else {
            self.scaledPose.joints[.rightHip]?.confidence = 0.0;
            self.scaledPose.joints[.rightHip]?.isValid =  false;
        }
        //rightKnee
        var pos_rKn = self.add(pos_rHi,multiply(ratio.rightHipToRightKnee, self.sub(p("rKn"),p("rHi"))))
        pos_rKn = self.multiply(tsRatio,pos_rKn)
        self.scaledPose.joints[.rightKnee]?.position = rePos(position: pos_rKn)
        if(pos_rKn != nil){
            self.scaledPose.joints[.rightKnee]?.confidence = 1.0;
            self.scaledPose.joints[.rightKnee]?.isValid =  true;
        }else {
            self.scaledPose.joints[.rightKnee]?.confidence = 0.0;
            self.scaledPose.joints[.rightKnee]?.isValid =  false;
        }
        //rightAnkle
        var pos_rAn = self.add(pos_rKn,multiply(ratio.rightKneeToRightAnkle, self.sub(p("rAn"),p("rKn"))))
        pos_rAn = self.multiply(tsRatio,pos_rAn)
        let scaledPos_rAn = rePos(position: pos_rAn)
        self.scaledPose.joints[.rightAnkle]?.position = scaledPos_rAn;
        if(pos_rAn == nil) {
            self.scaledPose.joints[.rightAnkle]?.confidence = 0.0;
            self.scaledPose.joints[.rightAnkle]?.isValid =  true;
        }else {
            self.scaledPose.joints[.rightAnkle]?.confidence = 1.0;
            self.scaledPose.joints[.rightAnkle]?.isValid =  false;
        }
        
        
        //left
        
        //leftShoulder
        var pos_lSh = self.multiply(ratio.originToLeftShoulder, p("lSh"))
        pos_lSh = self.multiply(tsRatio,pos_lSh)
        self.scaledPose.joints[.leftShoulder]?.position = rePos(position: pos_lSh)
        if(pos_lSh != nil) {
            self.scaledPose.joints[.leftShoulder]?.confidence = 1.0;
            self.scaledPose.joints[.leftShoulder]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftShoulder]?.confidence = 0.0;
            self.scaledPose.joints[.leftShoulder]?.isValid =  false;
        }
        //leftElbow
        var pos_lEl = self.add(pos_lSh,multiply(ratio.leftShoulderToLeftElbow, self.sub(p("lEl"),p("lSh"))))
        pos_lEl = self.multiply(tsRatio,pos_lEl)
        self.scaledPose.joints[.leftElbow]?.position = rePos(position: pos_lEl)
        if(pos_lEl != nil) {
            self.scaledPose.joints[.leftElbow]?.confidence = 1.0;
            self.scaledPose.joints[.leftElbow]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftElbow]?.confidence = 0.0;
            self.scaledPose.joints[.leftElbow]?.isValid =  false;
        }
        //leftWrist
        var pos_lWr = self.add(pos_lEl,multiply(ratio.leftElbowToLeftWrist, self.sub(p("lWr"),p("lEl"))))
        pos_lWr = self.multiply(tsRatio,pos_lWr)
        self.scaledPose.joints[.leftWrist]?.position = rePos(position: pos_lWr)
        if(pos_lWr != nil) {
            self.scaledPose.joints[.leftWrist]?.confidence = 1.0;
            self.scaledPose.joints[.leftWrist]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftWrist]?.confidence = 0.0;
            self.scaledPose.joints[.leftWrist]?.isValid =  false;
        }
        //leftHip
        var pos_lHi = self.multiply(ratio.originToLeftHip, p("lHi"))
        pos_lHi = self.multiply(tsRatio,pos_lHi)
        self.scaledPose.joints[.leftHip]?.position = rePos(position: pos_lHi)
        if(pos_lHi != nil) {
            self.scaledPose.joints[.leftHip]?.confidence = 1.0;
            self.scaledPose.joints[.leftHip]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftHip]?.confidence = 0.0;
            self.scaledPose.joints[.leftHip]?.isValid =  false;
        }
        //leftKnee
        var pos_lKn = self.add(pos_lHi,multiply(ratio.leftHipToLeftKnee, self.sub(p("lKn"),p("lHi"))))
        pos_lKn = self.multiply(tsRatio,pos_lKn)
        self.scaledPose.joints[.leftKnee]?.position = rePos(position: pos_lKn)
        if(pos_lKn != nil){
            self.scaledPose.joints[.leftKnee]?.confidence = 1.0;
            self.scaledPose.joints[.leftKnee]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftKnee]?.confidence = 0.0;
            self.scaledPose.joints[.leftKnee]?.isValid =  false;
        }
        //leftAnkle
        var pos_lAn = self.add(pos_lKn,multiply(ratio.leftKneeToLeftAnkle, self.sub(p("lAn"),p("lKn"))))
        pos_lAn = self.multiply(tsRatio,pos_lAn)
        self.scaledPose.joints[.leftAnkle]?.position = rePos(position: pos_lAn)
        if(pos_lAn != nil) {
            self.scaledPose.joints[.leftAnkle]?.confidence = 1.0;
            self.scaledPose.joints[.leftAnkle]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftAnkle]?.confidence = 0.0;
            self.scaledPose.joints[.leftAnkle]?.isValid =  false;
        }
        
        //face
        
        //(midpoint)
        var midpoint = multiply(0.5,self.add(p("rSh"),p("lSh")))
        var pos_midpoint = multiply(0.5,self.add(pos_rSh,pos_lSh))
        
        //rightEar
        var pos_rEa = self.add(pos_midpoint,multiply(ratio.midpointOfShouldersToRightEar, self.sub(p("rEa"),midpoint)))
        pos_rEa = self.multiply(tsRatio,pos_rEa)
        self.scaledPose.joints[.rightEar]?.position = rePos(position: pos_rEa)
        if(pos_rEa != nil) {
            self.scaledPose.joints[.rightEar]?.confidence = 1.0;
            self.scaledPose.joints[.rightEar]?.isValid =  true;
        }else {
            self.scaledPose.joints[.rightEar]?.confidence = 0.0;
            self.scaledPose.joints[.rightEar]?.isValid =  false;
        }
        
        //leftEar
        var pos_lEa = self.add(pos_midpoint,multiply(ratio.midpointOfShouldersToLeftEar, self.sub(p("lEa"),midpoint)))
        pos_lEa = self.multiply(tsRatio,pos_lEa)
        self.scaledPose.joints[.leftEar]?.position = rePos(position: pos_lEa)
        if(pos_lEa != nil) {
            self.scaledPose.joints[.leftEar]?.confidence = 1.0;
            self.scaledPose.joints[.leftEar]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftEar]?.confidence = 0.0;
            self.scaledPose.joints[.leftEar]?.isValid =  false;
        }
        
        scaledPose.confidence = teacherPose.confidence
        
        // 重心を計算して引き算
        
        return scaledPose
    }
    
    //add
    func add(_ positionA: CGPoint?, _ positionB: CGPoint?) -> CGPoint?
    {
        guard let posA = positionA,let posB = positionB else {
            return nil;
        }
        return CGPoint(x: posA.x + posB.x, y: posA.y + posB.y);
    }
    //sub
    func sub(_ positionA: CGPoint?, _ positionB: CGPoint?) -> CGPoint?
    {
        guard let posA = positionA,let posB = positionB else {
            return nil;
        }
        return CGPoint(x: posA.x - posB.x, y: posA.y - posB.y);
    }
    //multiply
    func multiply(_ a:Double?, _ position: CGPoint?) -> CGPoint?
    {
        guard let a1 = a,let pos = position else {
            return nil;
        }
        return CGPoint(x: a1*pos.x, y: a1*pos.y);
    }
    
    //p
    func p(_ name:String) -> CGPoint?
    {
        return self.sub(self.rawP(name), self.teacherCenterOfGravity);
    }
    //rawP
    func rawSP(_ name: String) -> CGPoint?
    {
        return rawPosition(name,self.studentPose)
    }
    func rawP(_ name: String) -> CGPoint?
    {
        return rawPosition(name,self.teacherPose)
    }
    func rawPosition(_ name: String,_ pose: Pose) -> CGPoint?
    {
        
        if(name == "nos"){
            return pose.joints[.nose]?.position;
        }else if (name == "lEy"){
            return pose.joints[.leftEye]?.position;
        }else if (name == "lEa"){
            return pose.joints[.leftEar]?.position;
        }else if (name == "lSh"){
            return pose.joints[.leftShoulder]?.position;
        }else if (name == "lEl"){
            return pose.joints[.leftElbow]?.position;
        }else if (name == "lWr"){
            return pose.joints[.leftWrist]?.position;
        }else if (name == "lHi"){
            return pose.joints[.leftHip]?.position;
        }else if (name == "lKn"){
            return pose.joints[.leftKnee]?.position;
        }else if (name == "lAn"){
            return pose.joints[.leftAnkle]?.position;
        }else if (name == "rEy"){
            return pose.joints[.rightEye]?.position;
        }else if (name == "rEa"){
            return pose.joints[.rightEar]?.position;
        }else if (name == "rSh"){
            return pose.joints[.rightShoulder]?.position;
        }else if (name == "rEl"){
            return pose.joints[.rightElbow]?.position;
        }else if (name == "rWr"){
            return pose.joints[.rightWrist]?.position;
        }else if (name == "rHi"){
            return pose.joints[.rightHip]?.position;
        }else if (name == "rKn"){
            return pose.joints[.rightKnee]?.position;
        }else if (name == "rAn"){
            return pose.joints[.rightAnkle]?.position;
        }
        return nil
    }
    
    
}
