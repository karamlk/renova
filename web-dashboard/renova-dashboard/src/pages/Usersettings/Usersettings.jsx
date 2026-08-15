import "./Usersettings.css";
//MUI Icons
import SettingsIcon from '@mui/icons-material/Settings';
import PersonIcon from '@mui/icons-material/Person';
import Avatar from '@mui/material/Avatar';
import AccountBoxIcon from '@mui/icons-material/AccountBox';
import SecurityIcon from '@mui/icons-material/Security';
import LockIcon from '@mui/icons-material/Lock';
import SaveIcon from '@mui/icons-material/Save';
import PhotoCameraIcon from '@mui/icons-material/PhotoCamera';
import Switch from '@mui/material/Switch';
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//api
import { getProfileRequest } from "../../api/auth";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
import { UserContext } from "../../Context/UserContext";
//api
import {updateProfileRequest} from "../../api/auth";
import {editActivationRequest} from "../../api/activation";
//Components
import Snackbar from "../../components/Snackbar/Snakbar";
import Changepassdialog from "../../components/Changepassdialog/Changepassdialog";
import Button from "../../components/Button/Button";
//Libraries
import dayjs from "dayjs";

export default function Settings() {
    const { t } = useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const {user,setUser}=useContext(UserContext);
    const [first_name,setfirst_name]=useState("");
    const [last_name,setlast_name]=useState("");
    const [phone,setphone]=useState("");
    const [location,setlocation]=useState("");
    const [image,setimage]=useState("");
    const [editFirstName, setEditFirstName] = useState(false);
    const [editLastName, setEditLastName] = useState(false);
    const [editPhone, setEditPhone] = useState(false);
    const [editLocation, setEditLocation] = useState(false);
    const [msg, setmsg] = useState("");
    const [isopen,setisopen] = useState(false);
    const [openchangepassdialog, setopenchangepassdialog] = useState(false);
    const [severity, setseverity] = useState("success");
    let role ={ 1:"مدير النظام"}
    let status={approved:"مقبول", rejected:"مرفوض"}
    let act ={0:"غير نشط" , 1:"نشط"}
    const imagePreview =image? URL.createObjectURL(image): user?.profile?.full_image_url ||"";
    function handleImageChange(e) {
        const file = e.target.files[0];
            if (!file) return;
            setimage(file);
        }
    //Request
    async function loadProfile() {
        setisloading(true);
        try{
        const response = await getProfileRequest();
        const data = response.data.data;
        setUser(data);
        setfirst_name(data?.profile?.first_name || "");
        setlast_name(data?.profile?.last_name || "");
        setphone(data?.profile?.phone || "");
        setlocation(data?.profile?.location || "");
        }
        catch (error) {
        console.error(error);
        } finally {
        setisloading(false);
        }

        }
    async function updateProfile(data) {
        const formData = new FormData();
              formData.append("first_name", first_name);
              formData.append("last_name", last_name);
              formData.append("phone", phone);
              formData.append("location", location);
         if (image) {formData.append("image", image);}
            try {
                setisloading(true);
                const response = await updateProfileRequest(formData);
                console.log(response.data.message);
                setEditFirstName(false);
                setEditLastName(false);
                setEditPhone(false);
                setEditLocation(false);
                await loadProfile();
                setmsg(response.data.message);
                
              } catch (error) {
                console.error(error);
              } finally {
                setisloading(false);
                setseverity("success");
                setisopen(true);
             }
        }                
    async function editActivation(id) {
            setUser(prev => ({
                ...prev,
                is_active: !prev.is_active,
            }));
        try {
            const response = await editActivationRequest(id);
            setmsg(response.data.message);
            setseverity("success");
            setisopen(true);
            } catch (error) {
                setUser(prev => ({
                    ...prev,
                    is_active: !prev.is_active,
                }));
                console.log(error);
            }        
        }
    
    useEffect(()=>{loadProfile();},[]);
    useEffect(() => {return () => {if (image) URL.revokeObjectURL(image);};},[image]);
    return (
            <div>
                {openchangepassdialog && <Changepassdialog 
                    onClose={() => setopenchangepassdialog(false)}
                    onSuccess={(message) => {
                        setopenchangepassdialog(false);
                        setmsg(message);
                        setseverity("success");
                        setisopen(true);
                    }}
                    onError={(message) => {
                        setopenchangepassdialog(false);
                        setmsg(message);
                        setseverity("error");
                        setisopen(true);
                    }}
                    />}
                <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
                <div className="page-header">
                    <h3><SettingsIcon sx={{color: "#f07c1f"}}/>{t("إعدادات الحساب")}</h3>
                </div>
                
                <div className="card">
                    <span className="card-title"><PersonIcon sx={{color: "#f07c1f"}}/> {t("الملف الشخصي")}</span>
                    <div className="avatar-row">
                        <div className="avatar-wrapper">
                            <div className="avatar">
                                <Avatar  src={imagePreview||undefined} alt="img" sx={{ width: 80, height: 80 }} >{!imagePreview && <PhotoCameraIcon />}</Avatar>
                            </div>
                                <div className="avatar-edit-icon" onClick={() => document.getElementById("fileInput").click()}><PhotoCameraIcon sx={{fontSize:"14px"}}/></div>
                                <input type="file" id="fileInput" accept="image/*" style={{display: "none"}} onChange={handleImageChange}/>
                        </div>
                        <div className="info">
                            <div className="name" id="displayName">{user?.profile?.first_name} {user?.profile?.last_name}</div>
                            <div className="role" id="displayRole">{t(role[user?.role_id])}</div>
                        </div>
                    </div>
                </div>

                <div className="card">
                    <span className="card-title"><AccountBoxIcon sx={{color: "#f07c1f"}}/>{t("المعلومات الشخصية")}</span>

                    <div className="card-row">
                        <span className="l">{t("الاسم")}</span>
                        <div className="field-group">
                             <span className="value-text">{user?.name}</span>
                        </div>
                    </div>
                    <div className="card-row">
                        <span className="l">{t("الاسم الأول")} </span>
                        <div className="field-group">
                            <input type="text" disabled={!editFirstName} value={first_name} onChange={(e) => setfirst_name(e.target.value)} />
                        </div>
                        <Button className="edit" onClick={() =>{(editFirstName?setEditFirstName(false):setEditFirstName(true))} } text="تعديل" />
                    </div>
                    <div className="card-row">
                        <span className="l">{t("الاسم الأخير")}</span>
                            <div className="field-group">
                                <input type="text" disabled={!editLastName}  value={last_name} onChange={(e) => setlast_name(e.target.value)} />
                            </div> 
                        <Button className="edit" onClick={()=>{(editLastName?setEditLastName(false):setEditLastName(true))}} text="تعديل" />
                    </div>
                    <div className="card-row">
                        <span className="l">{t("البريد الألكتروني")}</span>
                        <div className="field-group">
                            <span className="value-text">{user?.email}</span>
                        </div>
                    </div>
                    <div className="card-row">
                        <span className="l">{t("رقم الجوال")}</span>
                        <div className="field-group">
                            <input type="phone" disabled={!editPhone}  value={phone} onChange={(e) => setphone(e.target.value)} />
                        </div>
                        <Button className="edit" onClick={()=>{(editPhone?setEditPhone(false):setEditPhone(true))}} text="تعديل" />
                    </div>
                    <div className="card-row">
                        <span className="l">{t("مكان السكن")}</span> 
                        <div className="field-group">
                            <input type="text" disabled={!editLocation} value={location} onChange={(e) => setlocation(e.target.value)} />
                        </div>
                        <Button className="edit" onClick={()=>{(editLocation?setEditLocation(false):setEditLocation(true))}} text="تعديل" />
                    </div>
                    <div className="card-row">
                        <span className="l">{t("الحالة")}</span> 
                        <div className="field-group">
                            <span className="value-text">{t(status[user?.status])}</span>
                        </div>
                    </div>
                    <div className="card-row">
                        <span className="l">{t("النشاط")}</span> 
                        <div className="field-group">
                                <span className="value-text">{t(act[user?.is_active])}</span>
                            </div>
                        <Switch checked={user?.is_active} onChange={() => editActivation(user?.id)} color="warning" />
                    </div>
                </div>

                <div className="card">
                    <span className="card-title"><SecurityIcon sx={{color: "#f07c1f"}}/>{t("الأمان")}</span> 
            <div className="security-row">
                <div className="left">
                    <LockIcon sx={{color:"#e53935" , fontSize:40}}/>
                    <div>
                        <span className="label">{t("كلمة المرور")}</span>
                        <span className="sub-label">  {t("آخر تغيير")}: {dayjs(user?.updated_at).format("YYYY-MM-DD")}</span>
                    </div>
                </div>
                <Button className="change-pass" onClick={()=>setopenchangepassdialog(true)} icon={<LockIcon sx={{fontSize:20}}/>} text="تغيير كلمة المرور" />
            </div>  
                </div>

                <div className="card-actions">
                    <Button className="save" onClick={updateProfile} icon={<SaveIcon sx={{fontSize:20}}/>} text="حفظ" />
                </div>

            </div>

        
    )
}