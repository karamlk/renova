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
import Dialogform from "../Dialogform/Dialogform";
export default function Profiledialog({image,first_name,last_name,name,email,images,phone,location,role, onClose,children,showEdit = false,}) {
  const [t]=useTranslation();
  const navigate = useNavigate();
    return (
    <Dialogform
        title={"معلومات الحساب"} 
        icon={<AccountCircleIcon  sx={{ color: '#f07c1f' , fontSize: '35px' }}/>}
        h="560px" 
        w="480px"
        b1={<Button className="cancel" onClick={onClose} text="إغلاق" icon={<ClearIcon sx={{ fontSize: '16px' }}/>} />}
        b2={showEdit &&
          <Button className="accept" onClick={() => navigate("/dashboard/usersettings")} text="تعديل" icon={<EditIcon sx={{ fontSize: '16px' }}/>} />
        }>
               <div className="profile-row">
            {image} 
            <div className="profile-info">
              <h4>{first_name + " " + last_name}</h4>
              <span className="profile-role">{t(role)}</span>
            </div>
          </div>
          <div className="profile-field">
            <span className="profile-label">{t("اسم المستخدم")}</span>
            <span className="profile-value">{name}</span>
          </div>
          <div className="profile-field">
            <span className="profile-label">{t("الاسم الأول")}</span>
            <span className="profile-value">{first_name}</span>
          </div>
          <div className="profile-field">
            <span className="profile-label">{t("الاسم الأخير")}</span>
            <span className="profile-value">{last_name}</span>
          </div>
          <div className="profile-field">
            <span className="profile-label">{t("البريد الإلكتروني")}</span>
            <span className="profile-value">{email}</span>
          </div>
          <div className="profile-field">
            <span className="profile-label">{t("رقم الجوال")}</span>
            <span className="profile-value">{phone}</span>
          </div>
          <div className="profile-field">
            <span className="profile-label">{t("مكان السكن")}</span>
            <span className="profile-value">{location}</span>
          </div>
          {children}
    </Dialogform>
  );
}
  