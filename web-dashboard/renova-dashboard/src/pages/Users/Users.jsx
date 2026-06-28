import "./Users.css";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect } from "react";
//api
import {getUsersRequest} from "../../api/users";
//MUI Icons
import GroupIcon from '@mui/icons-material/Group';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import Avatar from '@mui/material/Avatar';
import AddIcon from '@mui/icons-material/Add';
import Switch from '@mui/material/Switch';
export default function User(){
    const [t] = useTranslation();
    const [users,setUsers] = useState([]);
     async function getUsers() {
            let response = await getUsersRequest();
            setUsers(response.data.data);
            console.log(response.data.data);
            }
    useEffect(()=>{getUsers();},[]);
    let role ={
        1:"مدير النظام",
        2:"مستخدم",
        3:"متعهد",
        4:"مهندس"
    }
    let status ={
        approved:"مقبول",
        rejected:"مرفوض",
        pending:"قيد الانتظار"
    }
    return(
        <div>
            <div className="users-table">
            <div className="table-header">
                <h3><GroupIcon sx={{ color: "#f07c1f"}}/> {t("المستخدمين")}</h3>
                <div className="table-actions">
                    <button className="btn-filter"><FilterAltIcon sx={{fontSize: "18px"}}/> {t("فلترة")}</button>
                    <button className="btn-refresh" onClick={getUsers}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                    {/*<button className="btn-add"><AddIcon sx={{fontSize: "18px"}}/> {t("إضافة")}</button>*/}
                </div>
            </div>
            <div className="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("الصورة")}</th>
                            <th>{t("اسم المستخدم")}</th>
                            <th>{t("رقم الجوال")}</th>
                            <th>{t("مكان السكن")}</th>
                            <th>{t("الدور")}</th>
                            <th>{t("تاريخ الإنشاء")}</th>
                            <th>{t("الحالة")}</th>
                            <th>{t("نشط")}</th>
                            <th>{t("الاجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {users.map((user) => (
                        <tr key={user.id}>
                        <td>
                            <div className="avatar">
                                {user?.profile?.full_image_url ? <Avatar  src={user?.profile?.full_image_url} alt="img" sx={{ width: 50, height: 50 }} />:<Avatar  alt=""  sx={{ width: 48, height: 48 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"   }} />   }
                            
                            </div>
                        </td>
                        <td>{user?.name} </td>
                        <td>{user?.profile?.phone? user?.profile?.phone : t("غير موجود")}</td>
                        <td className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{user?.profile?.location ? user?.profile?.location : t("غير موجود")}</td>
                        <td>{role[user?.role_id]}</td>
                        <td>{user?.created_at}</td>
                        <td>{status[user?.status]}</td>
                        <td><Switch checked={user?.is_active} color="warning" /></td>
                        <td>
                            <div className="actions">
                            {/* زر العرض */}
                            <Tooltip title={t("عرض")} arrow>


                                <IconButton className="action-btn" sx={{
                                        color: "#2196f3",
                                        backgroundColor: "rgba(33,150,243,0.1)",
                                        "&:hover": {
                                        backgroundColor: "#2196f3",
                                        color: "white",
                                        },
                                    }}>
                                <VisibilityIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>

                            {/* زر التعديل */}
                           {/*<Tooltip title={t("تعديل")} arrow>


                                <IconButton className="action-btn " sx={{
                                        color: "#f07c1f",
                                        backgroundColor: "rgba(240,124,31,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#f07c1f",
                                            color: "white",
                                        },
                                        }}>
                                <EditIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>*/} 

                            {/* زر الحذف */}
                            <Tooltip title={t("حذف")} arrow>

                                <IconButton className="action-btn" sx={{
                                        color: "#e53935",
                                        backgroundColor: "rgba(229,57,53,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#e53935",
                                            color: "white",
                                        },
                                        }}>
                                <DeleteIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>
                            </div>
                        </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
        </div>
        </div>
    );
}