//
//  ScaledPoseHelper.swift
//  PoseFinder
//
//  Created by tujing on 2023/07/11.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class ScaledPoseHealper {
    var teacherPose = Pose()
    var scaledPose = Pose()
    var teacherCenterOfGravity:CGPoint? = CGPoint()
    var ratio = TeacherStudentRatio.getInstance()
    
    init (teacherPose: Pose) {
        self.teacherPose = teacherPose;
        //先生のグラビティを計算
        self.teacherCenterOfGravity = self.multiply(0.25, add(add(rawP("rSh"), rawP("lSh")),add(rawP("rHi"), rawP("lHi"))));
    }
    func rePos (position:CGPoint?) -> CGPoint {
        if let pos = self.add(position,self.teacherCenterOfGravity) {
            return pos
        }
        return CGPoint(x: 0,y: 0)
    }
    
    func getScaledPose () -> Pose {
        
        //rightShoulder
        var pos_rSh = self.multiply(ratio.originToRightShoulder, p("rSh"))
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
        self.scaledPose.joints[.leftEar]?.position = rePos(position: pos_lEa)
        if(pos_lEa != nil) {
            self.scaledPose.joints[.leftEar]?.confidence = 1.0;
            self.scaledPose.joints[.leftEar]?.isValid =  true;
        }else {
            self.scaledPose.joints[.leftEar]?.confidence = 0.0;
            self.scaledPose.joints[.leftEar]?.isValid =  false;
        }
        
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
    
    func rawP(_ name: String) -> CGPoint?
    {
        
        if(name == "nos"){
            return self.teacherPose.joints[.nose]?.position;
        }else if (name == "lEy"){
            return self.teacherPose.joints[.leftEye]?.position;
        }else if (name == "lEa"){
            return self.teacherPose.joints[.leftEar]?.position;
        }else if (name == "lSh"){
            return self.teacherPose.joints[.leftShoulder]?.position;
        }else if (name == "lEl"){
            return self.teacherPose.joints[.leftElbow]?.position;
        }else if (name == "lWr"){
            return self.teacherPose.joints[.leftWrist]?.position;
        }else if (name == "lHi"){
            return self.teacherPose.joints[.leftHip]?.position;
        }else if (name == "lKn"){
            return self.teacherPose.joints[.leftKnee]?.position;
        }else if (name == "lAn"){
            return self.teacherPose.joints[.leftAnkle]?.position;
        }else if (name == "rEy"){
            return self.teacherPose.joints[.rightEye]?.position;
        }else if (name == "rEa"){
            return self.teacherPose.joints[.rightEar]?.position;
        }else if (name == "rSh"){
            return self.teacherPose.joints[.rightShoulder]?.position;
        }else if (name == "rEl"){
            return self.teacherPose.joints[.rightElbow]?.position;
        }else if (name == "rWr"){
            return self.teacherPose.joints[.rightWrist]?.position;
        }else if (name == "rHi"){
            return self.teacherPose.joints[.rightHip]?.position;
        }else if (name == "rKn"){
            return self.teacherPose.joints[.rightKnee]?.position;
        }else if (name == "rAn"){
            return self.teacherPose.joints[.rightAnkle]?.position;
        }
        return nil
    }
    
    
}
