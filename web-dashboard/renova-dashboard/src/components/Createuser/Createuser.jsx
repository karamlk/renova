import "./Createuser.css";
//MUI Icons
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import PersonIcon from '@mui/icons-material/Person';
import EmailIcon from '@mui/icons-material/Email';
import LockIcon from '@mui/icons-material/Lock';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import VisibilityIcon from '@mui/icons-material/Visibility';
import ClearIcon from '@mui/icons-material/Clear';
import SaveIcon from '@mui/icons-material/Save';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
//Hooks
import { useState } from "react";
import { useTranslation } from "react-i18next";
//api
import {createUserRequest}  from "../../api/users";
//Component
import Snackbar from "../Snackbar/Snakbar";
import Button from "../Button/Button";
export default function Createuser({onClose,onSuccess}) {
    const {t} = useTranslation();
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [profileload,setprofileload] = useState(false);
    const [msg,setmsg] = useState();
    const [isopen, setisopen] = useState(false);
    const [severity, setseverity] = useState("");
    //Requests
    async function handleSubmit() {
        try {
            setprofileload(true);
            let response = await createUserRequest(name,email,password,confirmPassword);
            setprofileload(false);
            onSuccess?.(t(response.data.message));
            onClose(); 
        }catch(error) {
            setprofileload(false);
            setmsg(t(error.response.data.message));
            setseverity("error");
            setisopen(true);
        }
    }
    return(
        <div>
            {profileload && <div className="page"></div>}
            {isopen && <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>}
            <div className="overlay-user">
                <div className="dialog-user">
                    <div className="dialog-header-user">
                        <div className="title">
                            <PersonAddIcon sx={{color:"#f07c1f"}} fontSize="large"/>
                            <h3>{t("إنشاء حساب مهندس")}</h3>
                        </div>
                    </div>
                    <div className="dialog-body-user">
                        <form id="addForm" onSubmit={(e) => { e.preventDefault(); handleSubmit(); }}>
                            <div className="form-group-user">
                                <label for="fullName">
                                    <PersonIcon sx={{color:"#f07c1f"}} />
                                   {t("الاسم الكامل")}
                                </label>
                                <input
                                    type="text"
                                    id="fullName"
                                    placeholder={t("أدخل الاسم الكامل")}
                                    value={name}
                                    onChange={(e) => setName(e.target.value)}
                                    
                                />
                            </div>
                            <div className="form-group-user">
                                <label for="email">
                                    <EmailIcon sx={{color:"#f07c1f"}} fontSize="small"/>
                                        {t("البريد الإلكتروني")}
                                </label>
                                <input
                                    type="email"
                                    id="email"
                                    placeholder="example@domain.com"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                    
                                />
                            </div>
                            <div className="form-group-user">
                                <label for="password">
                                    <LockIcon sx={{color:"#f07c1f"}} fontSize="small"/>
                                    {t("كلمة المرور")}
                                </label>
                                <div className="password-wrapper">
                                    <input
                                        type={showPassword ? 'text' : 'password'}
                                        id="password"
                                        placeholder="••••••••"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        
                                    />
                                    <span className="toggle-pass" onClick={() => {setShowPassword(!showPassword)}}>
                                        {showPassword ? (
                                            <VisibilityOffIcon sx={{ color: '#b8bcbf' }} />
                                        ) : (
                                            <VisibilityIcon sx={{ color: '#b8bcbf' }} />
                                        )}
                                    </span>
                                </div>
                            </div>
                            <div className="form-group-user">
                                <label for="confirmPassword">
                                    <CheckCircleIcon sx={{color:"#f07c1f"}} fontSize="small" />
                                    {t("إعادة كلمة المرور")}
                                </label>
                                <div className="password-wrapper">
                                    <input
                                        type={showConfirmPassword ? 'text' : 'password'}
                                        id="confirmPassword"
                                        placeholder="••••••••"
                                        value={confirmPassword}
                                        onChange={(e) => setConfirmPassword(e.target.value)}
                                        
                                    />
                                    <span className="toggle-pass" onClick={() => {setShowConfirmPassword(!showConfirmPassword)}}>
                                        {showConfirmPassword ? (
                                            <VisibilityOffIcon sx={{ color: '#b8bcbf' }} />
                                        ) : (
                                            <VisibilityIcon sx={{ color: '#b8bcbf' }} />
                                        )}
                                    </span>
                                </div>
                            </div>
                            <div className="dialog-footer-user">
                                <Button type="button" className="cancel" onClick={onClose} text="إلغاء" icon={<ClearIcon fontSize="small"/>}/>
                                <Button type="submit" className="accept" text="إضافة" icon={<SaveIcon fontSize="small"/>}/>       
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    )
}