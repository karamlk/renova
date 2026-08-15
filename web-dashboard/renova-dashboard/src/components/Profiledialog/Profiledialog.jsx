import './Profiledialog.css';

//MUI Icons
import EditIcon from '@mui/icons-material/Edit';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import ClearIcon from '@mui/icons-material/Clear';
//Hooks
import { useTranslation } from 'react-i18next';
import { useNavigate } from "react-router-dom";
//Components
import Button from '../Button/Button';
export default function Profiledialog({image,first_name,last_name,name,email,images,phone,location,role, onClose,children,showEdit = false,}) {
  const [t]=useTranslation();
  const navigate = useNavigate();
    return (
    <div className="dialog-overlay" onClick={onClose}>
      <div className="dialog-profile">

        <div className="dialog-header">
          <div className="title">
            <AccountCircleIcon  sx={{ color: '#f07c1f' }}/>
            <h3>{t("معلومات الحساب")}</h3>
          </div>
        </div>
        <div className="dialog-body">
          <div className="profile-row">
            {image} 
            <div className="info">
              <h4>{first_name + " " + last_name}</h4>
              <span className="role">{t(role)}</span>
            </div>
          </div>
          <div className="field">
            <span className="label">{t("اسم المستخدم")}</span>
            <span className="value">{name}</span>
          </div>
          <div className="field">
            <span className="label">{t("الاسم الأول")}</span>
            <span className="value">{first_name}</span>
          </div>
          <div className="field">
            <span className="label">{t("الاسم الأخير")}</span>
            <span className="value">{last_name}</span>
          </div>
          <div className="field">
            <span className="label">{t("البريد الإلكتروني")}</span>
            <span className="value">{email}</span>
          </div>
          <div className="field">
            <span className="label">{t("رقم الجوال")}</span>
            <span className="value">{phone}</span>
          </div>
          <div className="field">
            <span className="label">{t("مكان السكن")}</span>
            <span className="value">{location}</span>
          </div>
          {children}
        </div>
        <div className="dialog-footer">
          <Button className="cancel" onClick={onClose} text="إغلاق" icon={<ClearIcon sx={{ fontSize: '16px' }}/>} />
          {showEdit &&
          <Button className="accept" onClick={() => navigate("/dashboard/usersettings")} text="تعديل" icon={<EditIcon sx={{ fontSize: '16px' }}/>} />
          } 
        </div>
      </div>
    </div>
  );
}
  


