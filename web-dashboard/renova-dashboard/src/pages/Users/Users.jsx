import "./Users.css";
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
export default function User(){
    const users = [
        { id: 1,
          image:"", 
          first_name: "عبدالحكيم",
          last_name: "الصاج",
          phone: "0123456789",
          location: "القاهرة", 
          role: "متعهد", 
          created_at: "2023-01-01",
         },
         {
            id: 2,
            image:"", 
            first_name: "عبدالحكيم",
            last_name: "الصاج",
            phone: "0123456789",
            location: "القاهرة", 
            role: "مستخدم", 
            created_at: "2023-01-01",
         },
         {
            id: 3,
            image:"", 
            first_name: "عبدالحكيم",
            last_name: "الصاج",
            phone: "0123456789",
            location: "القاهرة", 
            role: "متعهد", 
            created_at: "2023-01-01",
         }

    ];
    return(
        <div>
<<<<<<< HEAD
            <div class="users-table">
            <div class="table-header">
                <h3><GroupIcon sx={{ color: "#f07c1f"}}/> المستخدمين</h3>
                <div class="table-actions">
                    <button class="btn-filter"><FilterAltIcon sx={{fontSize: "18px"}}/> فلترة</button>
                    <button class="btn-refresh"><RefreshIcon sx={{fontSize: "18px"}}/> تحديث</button>
                    <button class="btn-add"><AddIcon sx={{fontSize: "18px"}}/> إضافة</button>
                </div>
            </div>
            <div class="table-container">
=======
            <div className="users-table">
            <div className="table-header">
                <h3><GroupIcon sx={{ color: "#f07c1f"}}/> المستخدمين</h3>
                <div className="table-actions">
                    <button className="btn-filter"><FilterAltIcon sx={{fontSize: "18px"}}/> فلترة</button>
                    <button className="btn-refresh"><RefreshIcon sx={{fontSize: "18px"}}/> تحديث</button>
                    <button className="btn-add"><AddIcon sx={{fontSize: "18px"}}/> إضافة</button>
                </div>
            </div>
            <div className="table-container">
>>>>>>> 0fe71e9 (resolve merge conflicts keep css files)
                <table>
                    <thead>
                        <tr>
                            <th>الصورة</th>
                            <th>اسم المستخدم</th>
                            <th>رقم الجوال</th>
                            <th>مكان السكن</th>
                            <th>الدور</th>
                            <th>تاريخ الإنشاء</th>
                            <th>الاجراءات</th>
                        </tr>
                    </thead>
                   <tbody>
                    {users.map((user) => (
                        <tr key={user.id}>
                        <td>
                            <div className="avatar">
                            <Avatar  alt="Remy Sharp" src={user.image} sx={{ width: 48, height: 48 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"   }} />
                            </div>
                        </td>
                        <td>{user.first_name} {user.last_name}</td>
                        <td>{user.phone}</td>
                        <td className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{user.location}</td>
                        <td>{user.role}</td>
                        <td>{user.created_at}</td>
                        <td>
                            <div className="actions">
                            {/* زر العرض */}
                            <Tooltip title="عرض" arrow>
<<<<<<< HEAD
                                <IconButton className="action-btn view-btn">
=======
                                <IconButton className="action-btn" sx={{
                                        color: "#2196f3",
                                        backgroundColor: "rgba(33,150,243,0.1)",
                                        "&:hover": {
                                        backgroundColor: "#2196f3",
                                        color: "white",
                                        },
                                    }}>
>>>>>>> 0fe71e9 (resolve merge conflicts keep css files)
                                <VisibilityIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>

                            {/* زر التعديل */}
                            <Tooltip title="تعديل" arrow>
<<<<<<< HEAD
                                <IconButton className="action-btn edit-btn">
=======
                                <IconButton className="action-btn " sx={{
                                        color: "#f07c1f",
                                        backgroundColor: "rgba(240,124,31,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#f07c1f",
                                            color: "white",
                                        },
                                        }}>
>>>>>>> 0fe71e9 (resolve merge conflicts keep css files)
                                <EditIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>

                            {/* زر الحذف */}
                            <Tooltip title="حذف" arrow>
<<<<<<< HEAD
                                <IconButton className="action-btn delete-btn">
=======
                                <IconButton className="action-btn" sx={{
                                        color: "#e53935",
                                        backgroundColor: "rgba(229,57,53,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#e53935",
                                            color: "white",
                                        },
                                        }}>
>>>>>>> 0fe71e9 (resolve merge conflicts keep css files)
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