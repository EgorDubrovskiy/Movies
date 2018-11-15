<?php

namespace App\Models\MyLibrary;

class MyConvert{
    public static function arrayToStr(array $array): string{
        $res = "";
        for($i=0; $i<count($array); $i++){
            $res .= $array[$i].",";
        }
        return substr($res, 0, -1);
    }

    public static function arrayWithNameAndLastNameToStr(array $array): string{
        $res = "";
        for($i=0; $i<count($array['Name']); $i++)
            $res .= $array['Name'][$i].'.'.$array['LastName'][$i].',';
        return substr($res, 0, -1);
    }
}