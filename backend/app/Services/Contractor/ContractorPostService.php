<?php

namespace App\Services\Contractor;

use App\Models\ContractorPost;
use App\Models\ContractorPostImage;
use App\Models\Project;

class ContractorPostService
{
    /**
     * المشاريع المكتملة الخاصة بالمتعهد
     * والتي لم يتم إنشاء منشور لها بعد
     */
    public function availableProjects()
    {
        return Project::with([
            'constructionForm.reconstructionRequest',
            'constructionForm.materials',
            'engineer',
        ])
            ->where('contractor_id', auth()->id())
            ->where('status', 'completed')
            ->whereDoesntHave('post')
            ->latest()
            ->get();
    }


    /**
     * إنشاء منشور من مشروع مكتمل
     */
    public function store($request)
    {
        $project = Project::with([
            'form.reconstructionRequest',
            'form.materials',
            'engineer',
        ])
            ->where('id', $request->project_id)

            // حماية: المشروع لازم يكون للمتعهد الحالي
            ->where('contractor_id', auth()->id())

            // لازم يكون المشروع منجز
           // ->where('status', 'completed')

            ->firstOrFail();


        // المشروع ما لازم يكون إله منشور سابق
//        if ($project->post) {
//            throw new \Exception(
//                'تم إنشاء منشور لهذا المشروع مسبقاً'
//            );
//        }


        $post = ContractorPost::create([

            'project_id' => $project->id,

            'user_id' => auth()->id(),

            // اسم المشروع مأخوذ من طلب إعادة الإعمار
            'title' =>
                $project->form
                    ->reconstructionRequest
                    ->title,

            // الوصف الجديد الذي يدخله المتعهد
            'description' => $request->description,

            // بما أن المشروع مكتمل
            'status' =>$project->status

            ,

            'progress' => 100,
        ]);


        // الصور الجديدة الخاصة بالمنشور
        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {

                $path = $image->store(
                    'contractor-posts',
                    'public'
                );

                ContractorPostImage::create([

                    'contractor_post_id' =>
                        $post->id,

                    'image' => $path,
                ]);
            }
        }


        return $post->load([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.form.materials',
            'project.engineer',
        ]);
    }


    public function index()
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.engineer',
        ])
            ->withCount('likes')
            ->latest()
            ->get();
    }


    public function show($id)
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.form.materials',
            'project.engineer',
        ])
            ->withCount('likes')
            ->findOrFail($id);
    }


    /**
     * كل بوستات متعهد معين
     */
    public function contractorPosts($contractorId)
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.constructionForm.reconstructionRequest',
            'project.engineer',
        ])
            ->where('user_id', $contractorId)
            ->withCount('likes')
            ->latest()
            ->get();
    }


    public function update($request, $id)
    {
        $post = ContractorPost::findOrFail($id);

        // حماية: فقط صاحب البوست يستطيع تعديله
        if ($post->user_id !== auth()->id()) {
            throw new \Exception('غير مصرح لك');
        }

        // تعديل الوصف فقط إذا تم إرساله
        if ($request->filled('description')) {
            $post->update([
                'description' => $request->description,
            ]);
        }

        // إضافة صور جديدة بدون حذف الصور القديمة
        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {

                $path = $image->store(
                    'contractor-posts',
                    'public'
                );

                ContractorPostImage::create([
                    'contractor_post_id' => $post->id,
                    'image' => $path,
                ]);
            }
        }

        return $post->load([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.engineer',
        ]);
    }
    public function delete($id)
    {
        $post = ContractorPost::findOrFail($id);

        if ($post->user_id !== auth()->id()) {
            throw new \Exception(
                'غير مصرح لك'
            );
        }

        $post->delete();
    }
}
