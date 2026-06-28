import './Profiledialog.css';
//api
import { getProfileRequest } from "../../api/auth";
//MUI Icons
import EditIcon from '@mui/icons-material/Edit';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import Avatar from '@mui/material/Avatar';
//Hooks
import { useTranslation } from 'react-i18next';
import{useState,useEffect} from "react";
export default function Profiledialog({ onClose }) {
  const [t]=useTranslation();
    let role ={
        1:"مدير النظام",
        2:"مستخدم",
        3:"متعهد",
        4:"مهندس"
    }
        const[profile,setprofile]=useState({});
        useEffect(()=>{
            async function loadProfile() {
                let response = await getProfileRequest();
                setprofile(response.data.data);
                
            }
            loadProfile();
        },[]);
    return (
    <div className="dialog-overlay" onClick={onClose}>
      <div className="dialog-box1">

        <div className="dialog-header">
          <div className="title">
            <AccountCircleIcon  sx={{ color: '#f07c1f' }}/>
            <h3>{t("معلومات الحساب")}</h3>
          </div>
          
        </div>

        <div className="dialog-body">
          <div className="profile-row">
                {profile?.profile?.full_image_url ? <Avatar  src={profile?.profile?.full_image_url} alt="img" sx={{ width: 80, height: 80 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
                
            <div className="info">
              <h4>{profile?.profile?.first_name + " " + profile?.profile?.last_name}</h4>
              <span className="role">{t(role[profile?.role_id])} </span>
            </div>
          </div>

          <div className="field">
            <span className="label">{t("اسم المستخدم")}</span>
            <span className="value">{profile?.name}</span>
          </div>
          <div className="field">
            <span className="label">{t("الاسم الأول")}</span>
            <span className="value">{profile?.profile?.first_name}</span>
          </div>
          <div className="field">
            <span className="label">{t("الاسم الأخير")}</span>
            <span className="value">{profile?.profile?.last_name}</span>
          </div>
          <div className="field">
            <span className="label">{t("البريد الإلكتروني")}</span>
            <span className="value">{profile?.email}</span>
          </div>
          <div className="field">
            <span className="label">{t("رقم الجوال")}</span>
            <span className="value">{profile?.profile?.phone}</span>
          </div>
          <div className="field">
            <span className="label">{t("مكان السكن")}</span>
            <span className="value">{profile?.profile?.location}</span>
          </div>
        </div>

        <div className="dialog-footer">
          
          <button className="btn-edit" >
            <EditIcon sx={{ fontSize: '16px' }} />
            {t("تعديل")}
          </button>
          <button className="btn-cancel" onClick={onClose}>
            {t("إلغاء")}
          </button>
        </div>

      </div>
    </div>
  );
}
  


