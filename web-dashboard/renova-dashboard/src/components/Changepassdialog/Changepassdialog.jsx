import "./Changepassdialog.css";
//MUI Icons
import LockIcon from '@mui/icons-material/Lock';
import KeyIcon from '@mui/icons-material/Key';
import VisibilityIcon from '@mui/icons-material/Visibility';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import SaveIcon from '@mui/icons-material/Save';
import ClearIcon from '@mui/icons-material/Clear';
//Hooks
import { useState } from "react";
//api
import {updatePasswordRequest} from "../../api/auth";
//Components
import Snackbar from "../../components/Snackbar/Snakbar";
import Button from "../../components/Button/Button";
export default function Changepassdialog({onClose,onSuccess,onError}) {
    const [oldPassword, setOldPassword] = useState('');
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [showoldPassword, setShowoldPassword] = useState(false);
    const [shownewPassword, setShownewPassword] = useState(false);
    const [showconfirmPassword, setShowconfirmPassword] = useState(false);
    const [profileload,setprofileload] = useState(false);
    const [msg,setmsg] = useState('');
    const [isopen,setisopen]= useState(false);
    const [severity, setseverity] = useState('');
    //Requests
    async function changePassword(current_password,new_password,new_password_confirmation) {
        try{
            if(current_password==="" || new_password==="" || new_password_confirmation===""){
                    setmsg("كل الحقول مطلوبة");
                    setseverity("error");
                    setisopen(true);
                
            }else if(new_password !== new_password_confirmation){
                    setmsg("كلمة المرور غير متطابقة");
                    setseverity("error");
                    setisopen(true);
                
            }else{
                setprofileload(true);
                let response = await updatePasswordRequest(current_password,new_password,new_password_confirmation);
                onSuccess(response.data.message);  
                }
        }catch(error){
            setmsg(error.response.data.message);
            setseverity("error");
            setisopen(true);
        }finally{
            setprofileload(false);
        }
        
    }
    return(
        <div>
    {profileload && <div className="page"></div>}
    {isopen && <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>}
    <div className="pass-dialog-overlay" >
        <div className="pass-dialog-box">
            <div className="pass-dialog-header">
                <div className="pass-title">
                    <LockIcon sx={{color:"#f07c1f"}}/>
                    <h3 id="sub-title">تغيير كلمة المرور</h3>
                </div>
            </div>
            <div className="pass-dialog-body">
                <form id="passwordForm" onSubmit={(e)=>{e.preventDefault();changePassword(oldPassword,newPassword,confirmPassword)}} >

                    <div className="pass-form-group">
                        <label for="oldPassword">
                            <LockIcon sx={{color:"#f07c1f"}} fontSize="small"/> كلمة المرور الحالية
                        </label>
                        <div className="password-wrapper">
                            <input
                                type={showoldPassword ? 'text' : 'password'}
                                id="oldPassword"
                                value={oldPassword}
                                placeholder="أدخل كلمة المرور الحالية"
                                onChange={(e)=>{setOldPassword(e.target.value)}}
                                
                            />
                            <span className="toggle-pass" onClick={() => {setShowoldPassword(!showoldPassword)}}>
                                {showoldPassword ? (
                                        <VisibilityOffIcon sx={{ color: "#b8bcbf" }} />
                                    ) : (
                                        <VisibilityIcon sx={{ color: "#b8bcbf" }} />
                                    )}
                            </span>
                        </div>
                    </div>

                    <div className="pass-form-group">
                        <label for="newPassword">
                            <KeyIcon sx={{color:"#f07c1f"}} fontSize="small"/> كلمة المرور الجديدة
                        </label>
                        <div className="password-wrapper">
                            <input
                                type={shownewPassword ? 'text' : 'password'}
                                id="newPassword"
                                value={newPassword}
                                placeholder="أدخل كلمة المرور الجديدة"
                                onChange={(e)=>{setNewPassword(e.target.value)}}
                                
                            />
                            <span className="toggle-pass" onClick={() => {setShownewPassword(!shownewPassword)}}>
                                {shownewPassword ? (
                                        <VisibilityOffIcon sx={{ color: "#b8bcbf" }} />
                                    ) : (
                                        <VisibilityIcon sx={{ color: "#b8bcbf" }} />
                                    )}
                            </span>
                        </div>
                    </div>
                    <div className="pass-form-group">
                        <label for="confirmPassword">
                            <CheckCircleIcon sx={{color:"#f07c1f"}} fontSize="small"/> تأكيد كلمة المرور
                        </label>
                        <div className="password-wrapper">
                            <input
                                type={showconfirmPassword ? 'text' : 'password'}
                                id="confirmPassword"
                                value={confirmPassword}
                                placeholder="أعد إدخال كلمة المرور الجديدة"
                                onChange={(e)=>{setConfirmPassword(e.target.value)}}
                                
                            />
                            <span className="toggle-pass" onClick={() => {setShowconfirmPassword(!showconfirmPassword)}}>
                                {showconfirmPassword ? (
                                        <VisibilityOffIcon sx={{ color:"#b8bcbf" }} />
                                    ) : (
                                        <VisibilityIcon sx={{ color:"#b8bcbf" }} />
                                    )}
                            </span>
                        </div>
                    </div>
                    <div className="pass-dialog-footer">
                        <Button type="button" className="cancel" onClick={onClose} text="إلغاء" icon={<ClearIcon/>}/>
                        <Button type="submit" className="accept" text="تغيير" icon={<SaveIcon/>}/>    
                    </div>

                </form>

            </div>

        </div>
    </div>
    </div>
    )
}