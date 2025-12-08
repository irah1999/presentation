import { NextRequest, NextResponse } from 'next/server';

/**
 * POST /api/v1/ppt/anthropic/models/available
 * Fetches available Anthropic Claude models
 */
export async function POST(request: NextRequest) {
    try {
        const body = await request.json();
        const { api_key } = body;

        if (!api_key) {
            return NextResponse.json(
                { error: 'API key is required' },
                { status: 400 }
            );
        }

        // List of available Claude models
        const models = [
            'claude-3-5-sonnet-20241022',
            'claude-3-5-haiku-20241022',
            'claude-3-opus-20240229',
            'claude-3-sonnet-20240229',
            'claude-3-haiku-20240307',
        ];

        return NextResponse.json(models);
    } catch (error: any) {
        console.error('Error fetching Anthropic models:', error);
        return NextResponse.json(
            { error: error.message || 'Failed to fetch models' },
            { status: 500 }
        );
    }
}
