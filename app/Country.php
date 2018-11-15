<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Country extends Model
{
    protected $table = "Country";
    public $timestamps = false;
    
    //GET
    public static function GetAll(){
        return DB::select('exec GetAllCountries');
    }
    
    //POST
    public static function Add(string $Name){
        DB::insert('exec CreateCountry ?', array($Name));
    }
    
    //PUT
    public static function Edit(int $Id, string $NewName){
        DB::update('exec UpdateCountry ?, ?', array($Id, $NewName));
    }

    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteCountry ?', array($Id));
    }

}
